import Foundation
import UIKit

class ExtractImage {
    static func extractImageName1(url: String) -> UIImage? {
        let cleanedURL = url
            .replacingOccurrences(of: "//cdn.weatherapi.com/weather/64x64/", with: "")
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: "/", with: "")        
        if let image = UIImage(named: cleanedURL) {
            return image
        } else {
            return UIImage(named: "defaultImage")
        }
    }
    static func extractImageName(url: String?) -> String {
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
