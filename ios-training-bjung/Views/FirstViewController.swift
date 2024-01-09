//
//  FirstViewController.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/05.
//

import UIKit
import os

final class FirstViewController: UIViewController {
    
    private let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "firstView")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        logger.debug("FirstViewController deinit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Router.shared.showHomeView(from: self)
    }
}
