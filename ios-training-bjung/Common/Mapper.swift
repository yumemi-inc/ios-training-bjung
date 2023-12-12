//
//  Mapper.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/12.
//

import Foundation

final class Mapper {
    static let shared = Mapper()
    private init() {}
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    func encodeWeatherRequest(request: WeatherRequest) throws -> String {
        let jsonData = try encoder.encode(request)
        guard let result = String(data: jsonData, encoding: .utf8) else { fatalError("Failed to encode to JSON") }

        return result
    }
    
    func decodeWeatherResponse(json: String) throws -> WeatherResponse {
        guard let responseData = json.data(using: .utf8),
              let result = try? decoder.decode(WeatherResponse.self, from: responseData) else {
            fatalError("Failed to encode to JSON")
        }
        return result
    }
}
