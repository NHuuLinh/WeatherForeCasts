//
//  DatesCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 29/10/2023.
//

import UIKit

class DatesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var dateBackGroundColors: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        dateBackGroundColors.backgroundColor = UIColor.white
//        dateLb.text = nil
      }
      
    func bindData(date: String, isSelected: Bool) {
        dateLb.text = date
        if isSelected {
            dateBackGroundColors.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.14, alpha: 1.00)
            dateLb.textColor = UIColor.white
        } else {
            dateBackGroundColors.backgroundColor = UIColor.white
            dateLb.textColor = UIColor.black
        }
    }
}

