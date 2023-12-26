//
//  SelectedLocationsHistoryTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 25/12/2023.
//

import UIKit

class SelectedLocationsHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var historyLocationsLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        historyLocationsLb.text = UserDefaults.standard.string(forKey: "test")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getHistoryLocation(with location :String?){
//        print("location: \(location)")
        historyLocationsLb.text = location //as? String
    }
    
    
}
