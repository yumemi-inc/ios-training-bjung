//
//  FirstPresenter.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/19.
//

import Foundation
import YumemiWeather

protocol FirstPresenterInput {
    @MainActor
    func loadWeatherListData(at locations: [String], completion: @escaping ([WeatherListResponse]) -> ()) async
}

protocol FirstPresenterOutput: AnyObject {
    @MainActor
    func showAlertControllerByError(title: String, message: String)
}

final class FirstPresenter: FirstPresenterInput {
    private weak var view: FirstPresenterOutput?
    private var model: WeatherModelInput
    
    init(model: WeatherModelInput) {
        self.model = model
    }
    
    func inject(view: FirstPresenterOutput) {
        self.view = view
    }
    
    @MainActor
    func loadWeatherListData(at locations: [String], completion: @escaping ([WeatherListResponse]) -> ()) async {
        do {
            let request = WeatherListRequest(areas: locations, date: Date())
            let response = try await model.fetchWeatherListData(request: request)
            completion(response)
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
