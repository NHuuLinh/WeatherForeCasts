//
//  menuTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 12/11/2023.
//

import UIKit

enum MenuTitle {
    case addLocation
    case setting
    case notification
    case aboutUs
    case privatePolicy
    case termsOfUse
    var title: String {
        switch self {
        case .addLocation:
            return "Add Location"
        case .setting:
            return "Settings"
        case .notification:
            return "Notification"
        case .aboutUs:
            return "About Us"
        case .privatePolicy:
            return "Private Policy"
        case .termsOfUse:
            return "Terms Of Use"
        }
    }
}

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func getMenuTitle(title: MenuTitle) {
        titleLabel.text = title.title
    }
}
