//
//  ConvertToUIImage.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/26.
//

import Foundation
import UIKit

final class ConvertToUIImage {
    
    static func getDisplayUIImage(weatherCondition: String) -> UIImage {
        let imageResId: String
        let color: UIColor
        
        switch weatherCondition {
        case WeatherCondition.sunny.rawValue:
            imageResId = "ic_sunny"
            color = .red
        case WeatherCondition.rainy.rawValue:
            imageResId = "ic_rainy"
            color = .systemBlue
        case WeatherCondition.cloudy.rawValue:
            imageResId = "ic_cloudy"
            color = .gray
        default:
            fatalError("unknown result")
        }
        
        return UIImage(imageLiteralResourceName: imageResId).withTintColor(color)
    }
}
