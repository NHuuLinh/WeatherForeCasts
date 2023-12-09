
import Foundation
class DateConvert {
    static func convertDate(date: String, inputFormat: String, outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        // dũ liệu input
        dateFormatter.dateFormat = inputFormat
        if let date = dateFormatter.date(from: date) {
            // ngôn ngữ tiếng anh
//            dateFormatter.locale = Locale(identifier: "en_US")
            // dữ liêu output
            dateFormatter.dateFormat = outputFormat
            //chuyển về String
            let formattedDateString = dateFormatter.string(from: date)
            return formattedDateString
        } else {
            return "date error"
        }
    }
}
/*
kiểu dữ liệu thời gian  `dateFormat`:
 
 - **yyyy**: Năm bao gồm cả thế kỷ. Ví dụ: 2023
 - **yy**: Năm không bao gồm thế kỷ. Ví dụ: 23
 - **MM**: Tháng trong năm. Ví dụ: 07
 - **dd**: Ngày trong tháng. Ví dụ: 31
 - **HH**: Giờ trong ngày (định dạng 24 giờ). Ví dụ: 23
 - **hh**: Giờ trong ngày (định dạng 12 giờ). Ví dụ: 11
 - **mm**: Phút trong giờ. Ví dụ: 59
 - **ss**: Giây trong phút. Ví dụ: 59
 - **SSS**: Phần nghìn giây trong giây. Ví dụ: 999
 - **EEEE**: Tên đầy đủ của ngày trong tuần. Ví dụ: Monday
 - **EEE**: Tên viết tắt của ngày trong tuần. Ví dụ: Mon
 - **a**: Chỉ số AM/PM trong ngày. Ví dụ: AM
 "yyyy-MM-dd HH:mm:ss.SSS"
 */
