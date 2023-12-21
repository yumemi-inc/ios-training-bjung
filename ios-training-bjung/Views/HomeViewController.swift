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
}

extension HomeViewController: HomePresenterOutput {
    
    func updateInfoDisplay(imageResId: String, color: UIColor) {
        imageView.image = UIImage(imageLiteralResourceName: imageResId).withTintColor(color)
    }
    
    func showAlertControllerByError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}

