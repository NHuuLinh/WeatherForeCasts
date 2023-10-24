//
//  OnboardingCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 22/10/2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTilteLb: UILabel!
    @IBOutlet weak var slideDescriptionLb: UILabel!
    
    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
        slideTilteLb.text = slide.title
        slideDescriptionLb.text = slide.description
    }
}
