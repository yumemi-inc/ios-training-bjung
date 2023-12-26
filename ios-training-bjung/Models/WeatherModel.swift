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
    func fetchWeatherData(request: WeatherRequest, completion: @escaping @Sendable (Result<WeatherResponse, Error>) -> ())
    func fetchWeatherListData(request: WeatherListRequest) async throws -> [WeatherListResponse]
}


final class WeatherModel: WeatherModelInput {

    func fetchWeatherData() async throws -> String {
        return YumemiWeather.fetchWeatherCondition()
    }
    
    func fetchWeatherData(at location: String) async throws -> String {
        return try YumemiWeather.fetchWeatherCondition(at: location)
    }
    
    func fetchWeatherData(request: WeatherRequest) async throws -> WeatherResponse {
        let jsonString = try Mapper.encodeWeatherRequest(request: request)
        let response = try YumemiWeather.syncFetchWeather(jsonString)
        return try Mapper.decodeWeatherResponse(json: response)
    }

    func fetchWeatherData(request: WeatherRequest, completion: @escaping @Sendable (Result<WeatherResponse, Error>) -> ()) {
        Task {
            do {
                let jsonString = try Mapper.encodeWeatherRequest(request: request)
                let response = try YumemiWeather.syncFetchWeather(jsonString)
                let result = try Mapper.decodeWeatherResponse(json: response)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchWeatherListData(request: WeatherListRequest) async throws -> [WeatherListResponse]  {
        let jsonString = try Mapper.encodeWeatherListRequest(request: request)
        let response = try YumemiWeather.syncFetchWeatherList(jsonString)
        return try Mapper.decodeWeatherListResponse(json: response)
    }
}

struct WeatherRequest: Encodable {
    let area: String
    let date: Date
}

struct WeatherListRequest: Codable {
    let areas: [String]
    let date: Date
}

struct WeatherResponse: Decodable {
    let minTemperature: Int
    let maxTemperature: Int
    let weatherCondition: String
    let date: Date
}

extension WeatherResponse: Equatable {
}

struct WeatherListResponse: Decodable {
    let info: WeatherResponse
    let area: String
}
