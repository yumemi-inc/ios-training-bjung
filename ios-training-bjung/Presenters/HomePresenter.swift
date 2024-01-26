//
//  HomePresenter.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/01.
//

import Foundation
import YumemiWeather
import UIKit

protocol HomePresenterInput {
    @MainActor
    func loadWeatherData()
}

protocol HomePresenterOutput: AnyObject {
    @MainActor
    func showLoadingUI()
    @MainActor
    func updateDisplayScreen(updatedInfo response: WeatherResponse)
    @MainActor
    func showAlertControllerByError(title: String, message: String)
}

@MainActor
final class HomePresenter: HomePresenterInput {
    private weak var view: HomePresenterOutput?
    private var model: WeatherModelInput
    
    init(model: WeatherModelInput) {
        self.model = model
    }
    
    func inject(view: HomePresenterOutput) {
        self.view = view
    }
    
    func loadWeatherData() {
        // 非同期処理が行われることはないが、
        // API 通信が課題なのであえて async await を使って表現
        
        view?.showLoadingUI()
        let request = WeatherRequest(area: "tokyo", date: Date())
        model.fetchWeatherData(request: request) { result in
            switch (result) {
            case .success(let response):
                Task { @MainActor in
                    self.view?.updateDisplayScreen(updatedInfo: response)
                }
                
            case .failure(let error):
                Task { @MainActor in
                    switch error {
                    case YumemiWeatherError.invalidParameterError:
                        self.view?.showAlertControllerByError(title: "通信エラー", message: "妥当なリクエストではありません")
                    case YumemiWeatherError.unknownError:
                        self.view?.showAlertControllerByError(title: "通信エラー", message: "通信中にエラーが発生しました")
                    case let appError as AppError:
                        self.view?.showAlertControllerByError(title: "処理エラー", message: "処理にエラーが発生しました\n" + "エラーコード : \(appError.errorCode)")
                    default:
                        self.view?.showAlertControllerByError(title: "エラー", message: "原因不明のエラーが発生しました")
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
}
