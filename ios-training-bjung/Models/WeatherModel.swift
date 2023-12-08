//
//  WeatherModel.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/01.
//

import Foundation
import YumemiWeather

protocol WeatherModelInput {
    func fetchWeatherData() async throws -> String
    func fetchWeatherData(location: String) async throws -> String
}

final class WeatherModel: WeatherModelInput {
    
    private var yumemiWeather: YumemiWeather.Type
    
    init(yumemiWeather: YumemiWeather.Type) {
        self.yumemiWeather = yumemiWeather
    }
    
    func fetchWeatherData() async throws -> String {
        return yumemiWeather.fetchWeatherCondition()
    }
    
    func fetchWeatherData(location: String) async throws -> String {
        return try yumemiWeather.fetchWeatherCondition(at: location)
    }
}
