import Foundation
class DateFormate {
    static func dateConvert(date: String) -> String {
       let dateFormatter = DateFormatter()
       // dũ liệu input
       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
       if let date = dateFormatter.date(from: date) {
          // ngôn ngữ tiếng anh
          dateFormatter.locale = Locale(identifier: "en_US")
          // dữ liêu output
          dateFormatter.dateFormat = "dd-MM HH:mm EEEE"
          //chuyển về String
          let formattedDateString = dateFormatter.string(from: date)
          print(formattedDateString)
          return formattedDateString
       } else {
          return "date error"
       }
    }
}
