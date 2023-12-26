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
    func fetchWeatherData(at location: String) async throws -> String
    func fetchWeatherData(request: WeatherRequest) async throws -> WeatherResponse
}

final class WeatherModel: WeatherModelInput {
    private var yumemiWeather: YumemiWeather.Type
    
    init(yumemiWeather: YumemiWeather.Type) {
        self.yumemiWeather = yumemiWeather
    }
    
    func fetchWeatherData() async throws -> String {
        return yumemiWeather.fetchWeatherCondition()
    }
    
    func fetchWeatherData(at location: String) async throws -> String {
        return try yumemiWeather.fetchWeatherCondition(at: location)
    }
    
    func fetchWeatherData(request: WeatherRequest) async throws -> WeatherResponse {
        let jsonString = try Mapper.encodeWeatherRequest(request: request)
        let response = try yumemiWeather.fetchWeather(jsonString)
        return try Mapper.decodeWeatherResponse(json: response)
    }
}

struct WeatherRequest: Codable {
    let area: String
    let date: Date
}

struct WeatherResponse: Decodable {
    let minTemperature: Int
    let maxTemperature: Int
    let weatherCondition: String
    let date: Date
}
