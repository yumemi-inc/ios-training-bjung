//
//  ViewController.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/11/29.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {
    
    let weatherRepository = YumemiWeather.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onReloadButtonClick(_ sender: UIButton) {
        executeLoadData()
    }
    
    func executeLoadData() {
        Task {
            do {
                let result = try await loadWeatherData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadWeatherData() async throws -> String {
        return weatherRepository.fetchWeatherCondition()
    }
}

