//
//  DatesCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 29/10/2023.
//

import UIKit

class DatesCollectionViewCell: UICollectionViewCell,DateConvertFormat {
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var dateBackGroundColors: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      }
      
    func bindData(date: Forecastday, isSelected: Bool) {
        dateLb.text = convertDate(date: date.date, inputFormat: "yyyy-MM-dd", outputFormat: "dd/MM EEE")
//        dateLb.text = date
//        if isSelected {
//            dateBackGroundColors.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.14, alpha: 1.00)
//            dateLb.textColor = UIColor.white
//        } else {
//            dateBackGroundColors.backgroundColor = UIColor(named: "Color Main Theme")
//            dateLb.textColor = UIColor.black
//        }Color Font
        if isSelected {
            dateBackGroundColors.backgroundColor = UIColor(named: "Color Main Theme")
            dateLb.textColor = UIColor.white
        } else {
            dateBackGroundColors.backgroundColor = UIColor(named: "Color Font")
            dateLb.textColor = UIColor.black
        }
    }
}

