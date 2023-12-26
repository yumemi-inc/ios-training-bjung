//
//  ViewController.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/11/29.
//

import UIKit
import YumemiWeather
import os

private let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "homeView")

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    
    private var presenter: HomePresenterInput
    private let weatherInfo: WeatherResponse
    
    init?(coder: NSCoder, presenter: HomePresenterInput, weatherInfo: WeatherResponse) {
        self.presenter = presenter
        self.weatherInfo = weatherInfo
        super.init(coder: coder)
    }
    
    // 独自 init を作ったので必要になる
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        logger.debug("HomeViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(intoForeground), name: .onAppForeground, object: nil)
        updateDisplayScreen(updatedInfo: weatherInfo)
    }
    
    @objc func intoForeground() {
        loadWeatherData()
    }

    func loadWeatherData() {
        presenter.loadWeatherData()
    }

    @IBAction func onCloseButtonClick(_ sender: Any) {
        Router.shared.dissmiss(target: self)
    }
    
    @IBAction func onReloadButtonClick(_ sender: UIButton) {
        loadWeatherData()
    }
    
}

extension HomeViewController: HomePresenterOutput {
    
    func showLoadingUI() {
        indicator.startAnimating()
        reloadButton.isEnabled = false
    }
    
    func updateDisplayScreen(updatedInfo response: WeatherResponse) {
        imageView.image = ConvertToUIImage.getDisplayUIImage(weatherCondition: response.weatherCondition)
        minTemperatureLabel.text = String(response.minTemperature)
        maxTemperatureLabel.text = String(response.maxTemperature)
        indicator.stopAnimating()
        reloadButton.isEnabled = true
    }
    
    func showAlertControllerByError(title: String, message: String) {
        indicator.stopAnimating()
        reloadButton.isEnabled = true
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}

