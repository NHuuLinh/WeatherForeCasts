//
//  OnboardingCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 26/12/2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTilteLb: UILabel!
    @IBOutlet weak var slideDescriptionLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(with slide: OnboardingSlide) {
        slideImageView.image = UIImage(named: slide.image ?? "Onbroad3")
        slideTilteLb.text = slide.title
        slideDescriptionLb.text = slide.description
    }

}
