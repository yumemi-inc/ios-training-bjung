//
//  FirstViewController.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/05.
//

import UIKit
import os

private let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "firstView")

final class FirstViewController: UIViewController {
    
    @IBOutlet weak var weatherListTableView: UITableView!
    
    private var presenter: FirstPresenterInput
    private var weatherInfoList: [WeatherListResponse] = []
    
    init?(coder: NSCoder, presenter: FirstPresenterInput) {
        self.presenter = presenter
        super.init(coder: coder)
    }
    
    // 独自 init を作ったので必要になる
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherListTableView.refreshControl = UIRefreshControl()
        self.weatherListTableView.refreshControl?.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)

        loadWeatherListData()
    }
        
    func loadWeatherListData() {
        let locations = ["Tokyo", "Osaka", "Fukuoka", "Sendai", "Sapporo"]
        presenter.loadWeatherListData(at: locations)
    }
    
    @objc func refreshWeatherData() {
        loadWeatherListData()
    }
    
    deinit {
        Logger().debug("FirstViewController deinit")
    }
}

extension FirstViewController: FirstPresenterOutput {
    
    func showAlertControllerByError(title: String, message: String) {
        Router.shared.showAlertController(from: self, title: title, message: message)
        weatherListTableView.refreshControl?.endRefreshing()
    }
    
    func showDataList(response: [WeatherListResponse]) {
        weatherInfoList = response
        weatherListTableView.reloadData()
        weatherListTableView.refreshControl?.endRefreshing()
    }
}

extension FirstViewController: UITableViewDelegate {
    
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherListTableView.dequeueReusableCell(withIdentifier: "weatherListTableCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        cell.locationLabel.text = self.weatherInfoList[indexPath.row].area
        cell.weatherImageView.image = ConvertToUIImage.getDisplayUIImage(weatherCondition: self.weatherInfoList[indexPath.row].info.weatherCondition)
        cell.minTemperatureLabel.text = String(self.weatherInfoList[indexPath.row].info.minTemperature)
        cell.maxTemperatureLabel.text = String(self.weatherInfoList[indexPath.row].info.maxTemperature)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.showHomeView(from: self, weatherInfo: self.weatherInfoList[indexPath.row].info)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
