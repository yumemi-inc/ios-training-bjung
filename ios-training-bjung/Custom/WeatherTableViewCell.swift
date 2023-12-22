//
//  WeatherTableViewCell.swift
//  ios-training-bjung
//
//  Created by 鄭 普勤 on 2023/12/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
