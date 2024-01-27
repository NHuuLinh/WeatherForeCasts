
import Foundation

protocol UvValueHandle {
    func uvCondition(uvValue: Int) -> String
    func uvAdvice(uvValue: Double) -> String
}

extension UvValueHandle {
    // hàm nhận giá trị uv và trả về nhận xét
    func uvCondition(uvValue: Int) -> String {
        switch uvValue {
        case 1...2 :
            return "(low)"
        case 3...5 :
            return "(moderate)"
        case 6...7 :
            return "(high)"
        case 8...10 :
            return "(very High)"
        case 11...99 :
            return "(extrene)"
        default :
            return "(Error)"
        }
    }
    
    // hàm nhận giá trị uv và trả về lời khuyên
    func uvAdvice(uvValue: Double) -> String {
        switch uvValue {
        case 0...2 :
            return "Low UV index. You don't need special protection."
        case 3...5 :
            return "Average UV index. Wear protective clothing, a wide-brimmed hat, and UV-protective glasses"
        case 6...7 :
            return "High UV index. Seek shade, wear protective clothing, a wide-brimmed hat, and UV-protective glasses."
        case 8...10 :
            return "UV quality is very high. Seek shade, wear protective clothing, a wide-brimmed hat, UV-protective glasses, and use sunscreen"
        case 11...99 :
            return "UV quality is extremely dangerous. Avoid direct sun exposure, wear protective clothing, a wide-brimmed hat, UV-protective glasses and sunscreen."
        default :
            return "Error "
        }
    }
}
