//
//  LocationHistoryTitleTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 26/12/2023.
//

import UIKit

class LocationHistoryTitleTableViewCell: UITableViewCell {
    var onDataUpdate: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clearBtn(_ sender: Any) {
//        UserDefaults.standard.removeObject(forKey: "searchHistory")
        onDataUpdate?()
    }
}
