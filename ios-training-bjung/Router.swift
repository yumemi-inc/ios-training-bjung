//
//  Router.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/05.
//

import UIKit
import YumemiWeather

final class Router {
    static let shared = Router()
    private init() {}
    
    func showHomeView(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "HomeView", bundle: nil)
        
        let model = WeatherModel(yumemiWeather: YumemiWeather.self)
        let presenter = HomePresenter(model: model)
        let viewController = storyboard.instantiateInitialViewController() { coder in
            HomeViewController(coder: coder, presenter: presenter)
        }!
        
        presenter.inject(view: viewController)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        return window
    }
}
