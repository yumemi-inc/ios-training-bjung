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
        Task {
            do {
                view?.showLoadingUI()
                let request = WeatherRequest(area: "tokyo", date: Date())
                try await model.fetchWeatherData(request: request) { response in
                    self.view?.updateDisplayScreen(updatedInfo: response)
                }
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
