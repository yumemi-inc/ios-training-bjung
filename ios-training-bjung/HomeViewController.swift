//
//  ViewController.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/11/29.
//

import UIKit
import YumemiWeather

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var presenter: HomePresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let model = WeatherModel(yumemiWeather: YumemiWeather.self)
        self.presenter = HomePresenter(view: self, model: model)
    }

    @IBAction func onReloadButtonClick(_ sender: UIButton) {
        presenter.loadWeatherData()
    }
}

extension HomeViewController: HomePresenterOutput {
    
    func updateInfoDisplay(imageResId: String, color: UIColor) {
        imageView.image = UIImage(imageLiteralResourceName: imageResId).withTintColor(color)
    }
}
