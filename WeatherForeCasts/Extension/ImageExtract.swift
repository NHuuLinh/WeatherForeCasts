import Foundation
import UIKit

protocol ExtractImageFromUrl {
    func extractImageName(url: String?) -> String
}
extension ExtractImageFromUrl {
    // hàm trên ảng từ url 
    func extractImageName(url: String?) -> String {
        guard let url = url else {
            return "defaultImage"
        }
        let cleanedURL = url
            .replacingOccurrences(of: "//cdn.weatherapi.com/weather/64x64/", with: "")
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: "/", with: "")
        return cleanedURL
    }

}
