//
//  AppError.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/12.
//

import Foundation

public enum AppError: LocalizedError, Sendable {
    case jsonEncodeError
    case jsonDecodeError
    case unknownError
    
    public var errorDescription: String? {
        switch self {
        case .jsonEncodeError:
            return "Failed to encode to JSON"
        case .jsonDecodeError:
            return "Failed to decode to JSON"
        case .unknownError:
            return "Failed by unknown reason"
        }
    }
    
    public var errorCode: String {
        switch self {
        case .jsonEncodeError:
            return "0001"
        case .jsonDecodeError:
            return "0002"
        case .unknownError:
            return "9999"
        }
    }
}
