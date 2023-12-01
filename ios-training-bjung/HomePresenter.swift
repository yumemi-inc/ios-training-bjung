//
//  HomePresenter.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/01.
//

import Foundation
import YumemiWeather

protocol HomePresenterInput {
    @MainActor
    func loadWeatherData()
}

protocol HomePresenterOutput: AnyObject {
    func updateInfoDisplay(imageResId: String)
}

final class HomePresenter: HomePresenterInput {
    private weak var view: HomePresenterOutput!
    private var model: WeatherModelInput
    
    init(view: HomePresenterOutput, model: WeatherModelInput) {
        self.view = view
        self.model = model
    }
    
    @MainActor
    func loadWeatherData() {
        Task {
            do {
                let result = try await model.fetchWeatherData()
                let imageResId = getImageResId(response: result)
                
                view.updateInfoDisplay(imageResId: imageResId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getImageResId(response: String) -> String {
        let imageResId: String
        
        switch response {
        case "sunny": imageResId = "ic_sunny"
        case "rainy": imageResId = "ic_rainy"
        case "cloudy": imageResId = "ic_cloudy"
        default: fatalError("unknown result")
        }
        
        return imageResId
    }
}
