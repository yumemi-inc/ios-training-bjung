//
//  FirstViewController.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/05.
//

import UIKit
import os

final class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        Logger(subsystem: Bundle.main.bundleIdentifier!, category: "firstView").debug("FirstViewController deinit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Router.shared.showHomeView(from: self)
    }
}
