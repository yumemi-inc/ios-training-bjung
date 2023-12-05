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
    
    func showFirstView(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "FirstView", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        return window
    }
    
    func showHomeView(from: UIViewController) {
        let storyboard = UIStoryboard(name: "HomeView", bundle: nil)
        
        let model = WeatherModel(yumemiWeather: YumemiWeather.self)
        let presenter = HomePresenter(model: model)
        let viewController = storyboard.instantiateInitialViewController() { coder in
            HomeViewController(coder: coder, presenter: presenter)
        }!
        viewController.modalPresentationStyle = .fullScreen
        
        presenter.inject(view: viewController)
        
        show(from: from, to: viewController)
    }
    
    func dissmiss(target: UIViewController) {
        target.dismiss(animated: true)
    }

    private func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil) {
        from.present(to, animated: true)
    }
}
