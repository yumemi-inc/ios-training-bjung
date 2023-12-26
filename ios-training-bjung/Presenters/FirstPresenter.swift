//
//  FirstPresenter.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/19.
//

import Foundation

protocol FirstPresenterInput {
    @MainActor
    func loadWeatherListData(at locations: [String], completion: @escaping () -> ()) async
    func getWeahterInfoList() -> [WeatherListResponse]
}

protocol FirstPresenterOutput: AnyObject {
    
}

final class FirstPresenter: FirstPresenterInput {
    private weak var view: FirstPresenterOutput?
    private var model: WeatherModelInput
    private var infoList: [WeatherListResponse] = []
    
    init(model: WeatherModelInput) {
        self.model = model
    }
    
    func inject(view: FirstPresenterOutput) {
        self.view = view
    }
    
    @MainActor
    func loadWeatherListData(at locations: [String], completion: @escaping () -> ()) async {
        do {
            let request = WeatherListRequest(areas: locations, date: Date())
            infoList = try await model.fetchWeatherListData(request: request)
            completion()
        } catch let error as AppError {
            print(error.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getWeahterInfoList() -> [WeatherListResponse] {
        return infoList
    }
}
