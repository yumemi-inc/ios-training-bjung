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
    
    init?(coder: NSCoder, presenter: HomePresenterInput) {
        self.presenter = presenter
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
    }
    
    @objc func intoForeground() {
        loadWeatherData()
    }
    
    func loadWeatherData() {
        presenter.loadWeatherData { response in
            let resource = self.getDisplayResource(response: response.weatherCondition)
            
            self.imageView.image = UIImage(imageLiteralResourceName: resource.imageResId).withTintColor(resource.color)
            self.minTemperatureLabel.text = String(response.minTemperature)
            self.maxTemperatureLabel.text = String(response.maxTemperature)
            self.indicator.stopAnimating()
            self.reloadButton.isEnabled = true
        }
    }

    @IBAction func onCloseButtonClick(_ sender: Any) {
        Router.shared.dissmiss(target: self)
    }
    
    @IBAction func onReloadButtonClick(_ sender: UIButton) {
        loadWeatherData()
    }
    
    private func getDisplayResource(response: String) -> (imageResId: String, color: UIColor) {
        let imageResId: String
        let color: UIColor
        
        guard let weatherCondition = WeatherCondition(rawValue: response) else { fatalError("unknown result") }
        
        switch weatherCondition {
        case .sunny:
            imageResId = "ic_sunny"
            color = .red
        case .rainy:
            imageResId = "ic_rainy"
            color = .systemBlue
        case .cloudy:
            imageResId = "ic_cloudy"
            color = .gray
        }
        
        return (imageResId, color)
    }
}

extension HomeViewController: HomePresenterOutput {
    
    func showLoadingUI() {
        indicator.startAnimating()
        reloadButton.isEnabled = false
    }
    
    func showAlertControllerByError(title: String, message: String) {
        indicator.stopAnimating()
        reloadButton.isEnabled = true
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}

