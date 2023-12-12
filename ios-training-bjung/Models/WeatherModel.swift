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
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
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
        let jsonData = try WeatherModel.encoder.encode(request)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { fatalError("Failed to encode to JSON") }
        let response = try yumemiWeather.fetchWeather(jsonString)
        let decoder = WeatherModel.decoder
        guard let responseData = response.data(using: .utf8),
              let result = try? decoder.decode(WeatherResponse.self, from: responseData) else {
            fatalError("Failed to encode to JSON")
        }
        return result
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
