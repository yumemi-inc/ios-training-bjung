//
//  HomePresenter.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/01.
//

import Foundation
import YumemiWeather
import UIKit

protocol HomePresenterInput {
    @MainActor
    func loadWeatherData()
}

protocol HomePresenterOutput: AnyObject {
    func updateInfoDisplay(imageResId: String, color: UIColor)
}

final class HomePresenter: HomePresenterInput {
    private weak var view: HomePresenterOutput?
    private var model: WeatherModelInput
    
    init(model: WeatherModelInput) {
        self.model = model
    }
    
    func inject(view: HomePresenterOutput) {
        self.view = view
    }
    
    @MainActor
    func loadWeatherData() {
        // 非同期処理が行われることはないが、
        // API 通信が課題なのであえて async await を使って表現
        Task {
            do {
                // view が nil の場合、 api を実行せず処理を終了
                guard let view else { return }
                
                let result = try await model.fetchWeatherData()
                let resource = getDisplayResource(response: result)

                view.updateInfoDisplay(imageResId: resource.imageResId, color: resource.color)
            } catch {
                print(error.localizedDescription)
            }
        }
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
