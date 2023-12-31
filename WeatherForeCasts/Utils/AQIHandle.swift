//
//  AQI+Extension.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 11/11/2023.
//

import Foundation
import UIKit

class AQIHandle {
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
    static func airQlyColor(numb: Int) -> UIColor {
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
    static func airQlyDataCondition(numb: Int) -> String {
        switch numb {
        case 1 :
            return "(Good)"
        case 2 :
            return "(Moderate)"
        case 3 :
            return "(Unhealthy for sensitive group)"
//            return "(Not Good)"
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
    static func airQualityDataAdvice(index: Int) -> String {
        switch index {
        case 1:
            return "Great air quality, you don't need any protection."
        case 2:
            return "Good air quality, no significant health risk."
        case 3:
            return "Moderate air quality, sensitive individuals may experience respiratory issues. Consider reducing prolonged outdoor exertion."
        case 4:
            return "Poor air quality, everyone may begin to experience adverse health effects. Members of sensitive groups may experience more serious health effects."
        case 5:
            return "Very poor air quality, health alert: everyone may experience more serious health effects."
        case 6:
            return "Hazardous air quality, health warnings of emergency conditions. The entire population is likely to be affected."
        default:
            return "Data not available."
        }
    }

}
