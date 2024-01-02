import Foundation
import UIKit
import CoreData
import UIKit

class CoreDataHelper {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let managedContext = appDelegate.persistentContainer.viewContext
    static let locationFetchRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
    static let LocationfetchRequestObject = NSFetchRequest<NSManagedObject>(entityName: "LocationEntity")
    
    static let weatherFetchRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherDataEntity")
    static let weatherfetchRequestObject = NSFetchRequest<NSManagedObject>(entityName: "WeatherDataEntity")
    
    static func saveWeatherData(_ weatherData: WeatherData24h) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherDataEntity")
        // xóa dữ liệu cũ
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try CoreDataHelper.managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Lỗi khi xóa dữ liệu cũ từ CoreData: \(error)")
        }
        // Lưu giá trị mới
        guard let entity = NSEntityDescription.entity(forEntityName: "WeatherDataEntity",
                                                      in: CoreDataHelper.managedContext) else {return }
        let weatherDataEntity = NSManagedObject(entity: entity,
                                                insertInto: CoreDataHelper.managedContext)
        // Chuyển đổi WeatherData24h thành dữ liệu có thể lưu được (ví dụ: JSON)
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(weatherData) {
            weatherDataEntity.setValue(jsonData, forKey: "weatherData")
        }

        do {
            try CoreDataHelper.managedContext.save()
            UserDefaults.standard.didGetData = true
        } catch let error as NSError {
            print("Lỗi khi lưu dữ liệu vào CoreData: \(error)")
        }
    }
    static func deleteWeatherValue(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherDataEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataHelper.managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Lỗi khi xóa dữ liệu cũ từ CoreData: \(error)")
        }
    }
    
    static func deleteValue(){
//        var locationEntity: LocationEntity?
//        if let location = locationEntity {
//            CoreDataHelper.managedContext.delete(location)
//        }
//        do {
//            try CoreDataHelper.managedContext.save()
//        } catch let error as NSError {
//            print("lỗi delete dữ liệu : \(error)")
//        }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: CoreDataHelper.locationFetchRequestResult)
        do {
            try CoreDataHelper.managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Lỗi khi xóa dữ liệu cũ từ CoreData: \(error)")
        }
    }
    
    static func saveValue(){
        do {
            try CoreDataHelper.managedContext.save()
        } catch let error as NSError {
            print("lỗi lưu value: \(error)")
        }
    }
    static func saveValueToCoreData(address: String,longitude: Double,latitude: Double) {
        CoreDataHelper.deleteValue()
        guard let entity = NSEntityDescription.entity(forEntityName: "LocationEntity",in: CoreDataHelper.managedContext) else {return }
        let weatherDataEntity = NSManagedObject(entity: entity,
                                                insertInto: CoreDataHelper.managedContext)
        weatherDataEntity.setValue(address, forKey: "address")
        weatherDataEntity.setValue(longitude, forKey: "longitude")
        weatherDataEntity.setValue(latitude, forKey: "latitude")
        do {
            try CoreDataHelper.managedContext.save()
        } catch let error as NSError {
            print("lỗi khi lưu data :\(error)")
        }

        print("saveValueToCoreData:\(address),\(longitude),\(latitude)")
    }
    
    static func getValueFromCoreData(key: String) -> Any{
        do {
            let results = try CoreDataHelper.managedContext.fetch(CoreDataHelper.LocationfetchRequestObject)
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
    
    static func fetchWeatherData() -> WeatherData24h? {
        do {
            let results = try CoreDataHelper.managedContext.fetch(CoreDataHelper.weatherfetchRequestObject)
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
    
    static func fetchWeatherDataAll() -> (weatherData: WeatherData24h?,address: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return (nil,"nil")
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherDataEntity")
//        let coreData = WeatherDataEntity(context: managedContext)
//        let address = coreData.address
//        print("fetchWeatherData: \(address)")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if let firstResult = results.first as? NSManagedObject {
                // Lấy dữ liệu từ CoreData và chuyển đổi thành WeatherData24h
                if firstResult.value(forKey: "weatherData") is Data {
                    if let jsonData = firstResult.value(forKey: "weatherData") as? Data {
                        let jsonDecoder = JSONDecoder()
                        if let weatherData = try? jsonDecoder.decode(WeatherData24h.self, from: jsonData),
                            let address = firstResult.value(forKey: "address") as? String {
                            print("fetchWeatherData: \(address)")
                            return (weatherData,address)
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("Lỗi khi truy xuất dữ liệu từ CoreData: \(error)")
        }

        return (nil,"")
    }

//    static func getallItem()-> String{
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        do {
//            let results = try context.fetch(WeatherDataEntity.fetchRequest())
//            if let result = results.first {
//                let latitude = result.locationLatitude
//                print("getLatitude: \(latitude ?? "")")
//                return latitude ?? ""
//            }
//        }
//        catch let error as NSError {
//            print("Lỗi khi truy xuất dữ liệu từ CoreData: \(error)")
//        }
//        return "10"
//    }
//    static func creatItem(locationLatitude:String) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let newItem = WeatherDataEntity(context: context)
////        context.delete(newItem)
//        newItem.locationLatitude = locationLatitude
//        print("locationLatitude: \(locationLatitude)")
//        do {
//            try context.save()
//        }
//        catch {
//            //
//        }
//    }
//    static func creatItem1(address:String) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let newItem = WeatherDataEntity(context: context)
////        context.delete(newItem)
//        newItem.address = address
//        print("locationLatitude: \(address)")
//        do {
//            try context.save()
//        }
//        catch {
//            //
//        }
//    }
}
