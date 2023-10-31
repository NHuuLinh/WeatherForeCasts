//
//  Weather24hCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 24/10/2023.
//

import UIKit
import Kingfisher



class Weather24hCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    func runcode(){
//        bindData(news: news)
//    }
//    func bindData(news: Condition) {
//        if let newsImageString = news.icon {
//            let newsImageUrl = URL(string: newsImageString)
//            if let imageUrlString = newsImageUrl?.absoluteString {
//                print("Địa chỉ URL của hình ảnh: \(imageUrlString)")
//                
//                // Call the delegate method to pass the value
//            }
//            
//            weatherIconImageView.kf.setImage(with: newsImageUrl)
//        } else {
//            weatherIconImageView.image = UIImage(named: "warning")
//        }
//    }


}
