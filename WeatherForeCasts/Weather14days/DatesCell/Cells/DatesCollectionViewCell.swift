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
        dateBackGroundColors.backgroundColor = UIColor.white
//        dateLb.text = nil
      }
      
    func bindData(date title: String?) {
         dateLb.text = title
         print("date có title là : \(title ?? "")")
       }
  }

