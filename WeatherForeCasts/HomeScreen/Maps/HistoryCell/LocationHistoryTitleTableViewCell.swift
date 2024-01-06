//
//  LocationHistoryTitleTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 26/12/2023.
//

import UIKit

class LocationHistoryTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var ClearBtnTitle: UIButton!
    var onDataUpdate: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        searchTitle.text = NSLocalizedString(searchTitle.text ?? "", comment: "")
        ClearBtnTitle.setTitle(NSLocalizedString(ClearBtnTitle.currentTitle ?? "", comment: ""), for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clearBtn(_ sender: Any) {
        onDataUpdate?()
    }
}
