//
//  HomePresenter.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/01.
//

import Foundation
import YumemiWeather

protocol HomePresenterInput {
    func loadWeatherData()
}

protocol HomePresenterOutput: AnyObject {
    func updateInfoDisplay(result: String)
}

final class HomePresenter: HomePresenterInput {
    private weak var view: HomePresenterOutput!
    private var model: WeatherModelInput
    
    init(view: HomePresenterOutput, model: WeatherModelInput) {
        self.view = view
        self.model = model
    }
    
    func loadWeatherData() {
        Task {
            do {
                let result = try await model.fetchWeatherData()
                print(result)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
