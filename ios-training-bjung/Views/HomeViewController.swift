//
//  ViewController.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/11/29.
//

import UIKit
import YumemiWeather
import os

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    private var presenter: HomePresenterInput
    
    private let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "homeView")
    
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
    }

    @IBAction func onCloseButtonClick(_ sender: Any) {
        Router.shared.dissmiss(target: self)
    }
    
    @IBAction func onReloadButtonClick(_ sender: UIButton) {
        presenter.loadWeatherData()
    }
    
    private func getDisplayResource(response: String) -> (imageResId: String, color: UIColor) {
        let imageResId: String
        let color: UIColor
        
        switch response {
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
        
        return (imageResId, color)
    }
}

extension HomeViewController: HomePresenterOutput {
    
    func updateInfoDisplay(updatedInfo response: WeatherResponse) {
        let resource = getDisplayResource(response: response.weatherCondition)
        
        imageView.image = UIImage(imageLiteralResourceName: resource.imageResId).withTintColor(resource.color)
        minTemperatureLabel.text = String(response.minTemperature)
        maxTemperatureLabel.text = String(response.maxTemperature)
    }
    
    func showAlertControllerByError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}

