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

        // Do any additional setup after loading the view.
    }
    
    deinit {
        logger.debug("FirstViewController deinit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            await loadWeatherListData()
        }
    }
    
    func loadWeatherListData() async {
        let locations = ["Tokyo", "Osaka", "Fukuoka", "Sendai", "Sapporo"]
        await presenter.loadWeatherListData(at: locations) {
            
        }
    }
}

extension FirstViewController: FirstPresenterOutput {
    
}

extension FirstViewController: UITableViewDelegate {
    
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherListTableView.dequeueReusableCell(withIdentifier: "weatherListTableCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        cell.locationLabel.text = "tokyo"
        cell.weatherImageView.image = UIImage(imageLiteralResourceName: "ic_sunny")
        cell.minTemperatureLabel.text = "10"
        cell.maxTemperatureLabel.text = "20"

        return cell
    }
}
