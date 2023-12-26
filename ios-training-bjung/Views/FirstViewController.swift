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

        Task {
            await loadWeatherListData()
        }
    }
        
    func loadWeatherListData() async {
        let locations = ["Tokyo", "Osaka", "Fukuoka", "Sendai", "Sapporo"]
        await presenter.loadWeatherListData(at: locations) { response in
            self.weatherInfoList = response
            self.weatherListTableView.reloadData()
            self.weatherListTableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func refreshWeatherData() {
        Task {
            await loadWeatherListData()
        }
    }
    
    deinit {
        Logger().debug("FirstViewController deinit")
    }
}

extension FirstViewController: FirstPresenterOutput {
    
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
        cell.weatherImageView.image = getDisplayUIImage(weatherCondition: self.weatherInfoList[indexPath.row].info.weatherCondition)
        cell.minTemperatureLabel.text = String(self.weatherInfoList[indexPath.row].info.minTemperature)
        cell.maxTemperatureLabel.text = String(self.weatherInfoList[indexPath.row].info.maxTemperature)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.showHomeView(from: self, weatherInfo: self.weatherInfoList[indexPath.row].info)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getDisplayUIImage(weatherCondition: String) -> UIImage {
        let imageResId: String
        let color: UIColor
        
        switch weatherCondition {
        case "sunny":
            imageResId = "ic_sunny"
            color = .red
        case "rainy":
            imageResId = "ic_rainy"
            color = .systemBlue
        case "cloudy":
            imageResId = "ic_cloudy"
            color = .gray
        default:
            fatalError("unknown result")
        }
        
        return UIImage(imageLiteralResourceName: imageResId).withTintColor(color)
    }
}
