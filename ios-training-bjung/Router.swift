//
//  Router.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/05.
//

import UIKit
import YumemiWeather

@MainActor
final class Router {
    static let shared = Router()
    private init() {}
    
    func showFirstView(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "FirstView", bundle: nil)
        
        let model = WeatherModel()
        let presenter = FirstPresenter(model: model)
        let viewController = storyboard.instantiateInitialViewController() { coder in
            FirstViewController.init(coder: coder, presenter: presenter)
        }!
        presenter.inject(view: viewController)
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        return window
    }
    
    func showHomeView(from previousViewController: UIViewController, weatherInfo: WeatherResponse) {
        let storyboard = UIStoryboard(name: "HomeView", bundle: nil)
        
        let model = WeatherModel()
        let presenter = HomePresenter(model: model)
        let nextViewController = storyboard.instantiateInitialViewController() { coder in
            HomeViewController(coder: coder, presenter: presenter, weatherInfo: weatherInfo)
        }!
        nextViewController.modalPresentationStyle = .fullScreen
        
        presenter.inject(view: nextViewController)
        
        present(from: previousViewController, to: nextViewController)
    }
    
    func dissmiss(target: UIViewController) {
        target.dismiss(animated: true)
    }

    private func present(
        from previousViewController: UIViewController,
        to nextViewController: UIViewController
    ) {
        previousViewController.present(nextViewController, animated: true)
    }
}
