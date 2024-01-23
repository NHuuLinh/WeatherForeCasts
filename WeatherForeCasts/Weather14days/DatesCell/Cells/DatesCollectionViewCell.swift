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
        if isSelected {
            dateBackGroundColors.backgroundColor = UIColor(named: "Color Main Theme")
            dateLb.textColor = UIColor.white
        } else {
            dateBackGroundColors.backgroundColor = UIColor(named: "Color Font")
            dateLb.textColor = UIColor.black
        }
    }
}

