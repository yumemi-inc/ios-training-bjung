//
//  FirstPresenter.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/19.
//

import Foundation

protocol FirstPresenterInput {
    @MainActor
    func loadWeatherListData()
}

protocol FirstPresenterOutput: AnyObject {
    
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
    func loadWeatherListData() {
        
    }
}
