//
//  Animation.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 21/12/2023.
//

import Foundation
import UIKit

class AnimationHandle {

    static func astroAnimetion(endAngle: CGFloat, rootImage:UIImageView, animationImage: UIImageView ) {
        let path = UIBezierPath()
        let xcordate = rootImage.frame.minX + 25
//        print("xcordate: \(xcordate)")
        let ycordate = rootImage.frame.maxY - 15
//        print("ycordate: \(ycordate)")
        let value: CGFloat = 110
        path.move(to: CGPoint(x: xcordate, y: ycordate))
        let startAngle = CGFloat.pi  // Bắt đầu từ phía trên
//        print("\(startAngle)")
        path.addArc(withCenter: CGPoint(x: xcordate + value/2, y: ycordate),
                    radius: value/2,
                    startAngle: CGFloat.pi,
                    endAngle: -CGFloat.pi*endAngle,
//                    endAngle: -CGFloat.pi*1,

                    clockwise: true)

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 2
        animation.repeatCount = 1
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animationImage.layer.add(animation, forKey: "curveAnimation")
        animationImage.layer.position = CGPoint(x: xcordate, y: ycordate + value)
    }
    
}
