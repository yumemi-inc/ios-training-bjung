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
    
    @IBOutlet weak var weatherListTableView: UITableView!
    
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
        weatherListTableView.frame = view.frame
        weatherListTableView.delegate = self
        weatherListTableView.dataSource = self
    }
    
    deinit {
        logger.debug("FirstViewController deinit")
    }
}

extension FirstViewController: FirstPresenterOutput {
    
}

extension FirstViewController: UITableViewDelegate {
    
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = weatherListTableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = "sample"
        return cell
    }
    
    
}
