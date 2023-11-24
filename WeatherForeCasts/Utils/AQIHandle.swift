//
//  AQI+Extension.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 11/11/2023.
//

import Foundation
import UIKit

class AQIHeper {
    static func airQlyLevel(width: Int) -> CGFloat {
        let level :CGFloat = 50.0
        switch width {
        case 1 :
            return level
        case 2 :
            return level*2
        case 3 :
            return level*3
        case 4 :
            return level*4
        case 5 :
            return level*5
        case 6 :
            return level*6
        default :
            return 0.0
        }
    }
    func airQlyColor(numb: Int) -> UIColor {
        switch numb {
        case 1 :
            return .green
        case 2 :
            return .yellow
        case 3 :
            return .orange
        case 4 :
            return .red
        case 5 :
            return .brown
        case 6 :
            return .purple
        default :
            return .white
        }
    }
    func airQlyDataCell(numb: Int) -> String {
        switch numb {
        case 1 :
            return "(Good)"
        case 2 :
            return "(Moderate)"
        case 3 :
            return "(Unhealthy for sensitive group)"
        case 4 :
            return "(Unhealthy)"
        case 5 :
            return "(Very Unhealthy)"
        case 6 :
            return "(Hazardous)"
        default :
            return "(Unknow)"
        }
    }
}
