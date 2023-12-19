//
//  FirstViewController.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/05.
//

import UIKit
import os

private let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "firstView")

final class FirstViewController: UIViewController {
    
    private var presenter: FirstPresenterInput
    
    init?(coder: NSCoder, presenter: FirstPresenterInput) {
        self.presenter = presenter
        super.init(coder: coder)
    }
    
    // 独自 init を作ったので必要になる
    required init?(coder: NSCoder) {
        fatalError()
    }

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

extension FirstViewController: FirstPresenterOutput {
    
}
