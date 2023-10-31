//
//  testCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 30/10/2023.
//

import UIKit

class testCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backGroundColors: UIView!
    @IBOutlet weak var textLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundColors.backgroundColor = UIColor(named: "red")
        // Initialization code
    }
//    func blindData(text: String, backgoundColors : String) {
//        textLB.text = text
//        backGroundColors.backgroundColor = UIColor(named: backgoundColors)
//    }

}
