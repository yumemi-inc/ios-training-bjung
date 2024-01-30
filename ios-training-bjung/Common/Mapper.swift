//
//  Mapper.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/12.
//

import Foundation

// 列挙型にしてインスタンス化できないことを担保する
enum Mapper {
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return dateFormatter
    }()
    
    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    static func encodeWeatherRequest(request: WeatherRequest) throws -> String {
        guard let jsonData = try? encoder.encode(request),
              let result = String(data: jsonData, encoding: .utf8) else {
            throw AppError.jsonEncodeError
        }
        return result
    }
    
    static func decodeWeatherResponse(json: String) throws -> WeatherResponse {
        guard let responseData = json.data(using: .utf8),
              let result = try? decoder.decode(WeatherResponse.self, from: responseData) else {
            throw AppError.jsonDecodeError
        }
        return result
    }
}
