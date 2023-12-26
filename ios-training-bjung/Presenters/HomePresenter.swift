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
    func updateInfoDisplay(updatedInfo response: WeatherResponse)
    func showAlertControllerByError(title: String, message: String)
}

final class HomePresenter: HomePresenterInput {
    private weak var view: HomePresenterOutput?
    private var model: WeatherModelInput
    
    init(model: WeatherModelInput) {
        self.model = model
    }
    
    func inject(view: HomePresenterOutput) {
        self.view = view
    }
    
    @MainActor
    func loadWeatherData() {
        // 非同期処理が行われることはないが、
        // API 通信が課題なのであえて async await を使って表現
        Task {
            do {
                let request = WeatherRequest(area: "tokyo", date: Date())
                let response = try await model.fetchWeatherData(request: request)
                
                view?.updateInfoDisplay(updatedInfo: response)
            } catch let error as YumemiWeatherError {
                switch error {
                case YumemiWeatherError.invalidParameterError:
                    view?.showAlertControllerByError(title: "通信エラー", message: "妥当なリクエストではありません")
                case YumemiWeatherError.unknownError:
                    view?.showAlertControllerByError(title: "通信エラー", message: "原因不明のエラーが発生しました")
                }
                print(error.localizedDescription)
            } catch let error as AppError {
                view?.showAlertControllerByError(title: "処理エラー", message: "処理にエラーが発生しました\n" + "エラーコード : \(error.errorCode)")
                print(error.localizedDescription)
            } catch {
                view?.showAlertControllerByError(title: "エラー", message: "原因不明のエラーが発生しました")
                print(error.localizedDescription)
            }
        }
    }
}
