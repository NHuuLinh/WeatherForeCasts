import Foundation
import UIKit
import CoreData
import UIKit

class CoreDataHelper {
    static let share = CoreDataHelper()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let locationFetchRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
    let locationfetchRequestObject = NSFetchRequest<NSManagedObject>(entityName: "LocationEntity")
    
    let weatherFetchRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherDataEntity")
    let weatherfetchRequestObject = NSFetchRequest<NSManagedObject>(entityName: "WeatherDataEntity")
    
    let profileFetchRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileEntity")
    let profilefetchRequestObject = NSFetchRequest<NSManagedObject>(entityName: "ProfileEntity")
    
    func saveValue(){
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("lỗi lưu value: \(error)")
        }
    }
    
    func deleteLocationValue(){
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: locationFetchRequestResult)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Lỗi khi xóa dữ liệu cũ từ CoreData: \(error)")
        }
    }
    
    func saveLocationValueToCoreData(address: String,longitude: Double,latitude: Double) {
        deleteLocationValue()
        guard let entity = NSEntityDescription.entity(forEntityName: "LocationEntity",in: managedContext) else {return }
        let weatherDataEntity = NSManagedObject(entity: entity,
                                                insertInto: managedContext)
        weatherDataEntity.setValue(address, forKey: "address")
        weatherDataEntity.setValue(longitude, forKey: "longitude")
        weatherDataEntity.setValue(latitude, forKey: "latitude")
        saveValue()
        print("saveValueToCoreData:\(address),\(longitude),\(latitude)")
    }
    
    func getLocationValueFromCoreData(key: String) -> Any{
        do {
            let results = try managedContext.fetch(locationfetchRequestObject)
            for result in results {
                if let value = result.value(forKey: "\(key)") {
                    return value
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return ""
    }
}
// MARK: - CoreDate WeatherData
extension CoreDataHelper {
    
    func deleteWeatherValue(){
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: weatherFetchRequestResult)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Lỗi khi xóa dữ liệu cũ từ CoreData: \(error)")
        }
    }
    
    func saveWeatherData(_ weatherData: WeatherData24h) {
        deleteWeatherValue()
        // Lưu giá trị mới
        guard let entity = NSEntityDescription.entity(forEntityName: "WeatherDataEntity",
                                                      in: managedContext) else {return }
        let weatherDataEntity = NSManagedObject(entity: entity,
                                                insertInto: managedContext)
        // Chuyển đổi WeatherData24h thành dữ liệu có thể lưu được (ví dụ: JSON)
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(weatherData) {
            weatherDataEntity.setValue(jsonData, forKey: "weatherData")
        }
        do {
            try managedContext.save()
            UserDefaults.standard.didGetData = true
        } catch let error as NSError {
            print("Lỗi khi lưu dữ liệu vào CoreData: \(error)")
        }
    }
    
    func fetchWeatherData() -> WeatherData24h? {
        do {
            let results = try managedContext.fetch(weatherfetchRequestObject)
            for result in results {
                if let weatherData = result.value(forKey: "weatherData") as? Data{
                    let jsonDecoder = JSONDecoder()
                    if let weatherData = try? jsonDecoder.decode(WeatherData24h.self, from: weatherData) {
                        return weatherData
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
// MARK: - Lưu CoreDate User Profile
extension CoreDataHelper {
    
    func deleteProfileValue(){
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: profileFetchRequestResult)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Lỗi khi xóa dữ liệu cũ từ CoreData: \(error)")
        }
    }
    func saveProfileValueToCoreData(avatar: UIImage,name: String,dateOfBirth: String,phoneNumber: String,gender: String ) {
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: profileFetchRequestResult)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Lỗi khi xóa dữ liệu cũ từ CoreData: \(error)")
        }
        // lưu dữ liệu vào FileManager
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("AvatarImage")
        if let data = avatar.pngData() {
            try? data.write(to: fileURL)
            
            guard let entity = NSEntityDescription.entity(forEntityName: "ProfileEntity",in: managedContext) else {return }
            let ProfileDataEntity = NSManagedObject(entity: entity,
                                                    insertInto: managedContext)
            ProfileDataEntity.setValue("AvatarImage", forKey: "avatar")
            ProfileDataEntity.setValue(name, forKey: "name")
            ProfileDataEntity.setValue(dateOfBirth, forKey: "dateOfBirth")
            ProfileDataEntity.setValue(phoneNumber, forKey: "phoneNumber")
            ProfileDataEntity.setValue(gender, forKey: "gender")
            print("saveProfileValueToCoreData success")
            saveValue()
        }
    }
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
            
            let entity = NSEntityDescription.entity(forEntityName: "ProfileEntity", in: managedContext)!
            let entities = NSEntityDescription.entity(forEntityName: "ProfileEntity", in: managedContext)
            let record = NSManagedObject(entity: entity, insertInto: managedContext)
            record.setValue(fileName, forKey: "avatar")
            saveValue()
        }
    }
    
    func loadImageFromFile(fileName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image from file: \(error)")
            return nil
        }
    }
    
    func getProfileValueFromCoreData(key: String)-> Any {
        do {
            let results = try managedContext.fetch(profilefetchRequestObject)
            for result in results {
                if let value = result.value(forKey: "\(key)") {
                    print("getValue:\(value)")
                    return value
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return ""
    }
    func getProfileValuesFromCoreData() -> (avatar: UIImage?, name: String?, dateOfBirth: String?, phoneNumber: String?, gender: String?) {
        let avatar = loadImageFromFile(fileName: "AvatarImage")
        do {
            let results = try managedContext.fetch(profilefetchRequestObject)
            if let result = results.last {
                if let name = result.value(forKey: "name") as? String,
                   let dateOfBirth = result.value(forKey: "dateOfBirth") as? String,
                   let phoneNumber = result.value(forKey: "phoneNumber") as? String,
                   let gender = result.value(forKey: "gender") as? String {
                    return (avatar, name, dateOfBirth, phoneNumber, gender)
                } else {
                    print("fail result")
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        print("fail")
        // Return nil values in case of any error or if no data is found
        return (nil, nil, nil, nil, nil)
    }
    
}
