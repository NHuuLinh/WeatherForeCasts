//
//  LocationEntity+CoreDataProperties.swift
//  
//
//  Created by LinhMAC on 03/01/2024.
//
//

import Foundation
import CoreData



extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
