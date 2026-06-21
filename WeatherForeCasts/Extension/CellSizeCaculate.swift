//
//  CellSizeCaculate.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 22/6/26.
//


import Foundation

import Foundation
protocol CellSizeCaculate {
    func caculateSize(indexNumber: Double, frameSize: Double, defaultNumberItemOneRow: Double,minimumLineSpacing: Double) -> Double
}
extension CellSizeCaculate {
    func caculateSize(indexNumber: Double, frameSize: Double, defaultNumberItemOneRow: Double,minimumLineSpacing: Double) -> Double {
        var imageSize:CGFloat
        if indexNumber <= defaultNumberItemOneRow {
            imageSize = ((frameSize - ((indexNumber - 1) * minimumLineSpacing))/indexNumber)
        } else {
            imageSize = ((frameSize - ((defaultNumberItemOneRow - 1) * minimumLineSpacing))/defaultNumberItemOneRow)
        }
        return imageSize
    }
}
