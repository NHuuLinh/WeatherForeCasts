//
//  WeatherDataEntity+CoreDataProperties.swift
//  
//
//  Created by LinhMAC on 03/01/2024.
//
//

import Foundation
import CoreData


extension WeatherDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDataEntity> {
        return NSFetchRequest<WeatherDataEntity>(entityName: "WeatherDataEntity")
    }

    @NSManaged public var weatherData: NSObject?

}
