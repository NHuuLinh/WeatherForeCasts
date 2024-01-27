//
//  AQI+Extension.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 11/11/2023.
//

import Foundation
import UIKit

protocol AQIHandle {
    func airQlyLevel(width: Int) -> CGFloat
    func airQlyColor(numb: Int) -> UIColor
    func airQlyDataCondition(numb: Int) -> String
    func airQualityDataAdvice(index: Int) -> String
}

extension AQIHandle {
    // hàm nhận giá trị aqi và trả về chiều dài của thanh slider
    func airQlyLevel(width: Int) -> CGFloat {
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
    // hàm nhận giá trị aqi và trả về màu của thanh slider
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
    // hàm nhận giá trị aqi và trả về nhận xét về chỉ số aqi
    func airQlyDataCondition(numb: Int) -> String {
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
    // hàm nhận giá trị aqi và trả về nhận xét dựa trên chỉ số aqi

    func airQualityDataAdvice(index: Int) -> String {
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
