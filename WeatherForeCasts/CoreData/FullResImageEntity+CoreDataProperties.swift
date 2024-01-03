//
//  FullResImageEntity+CoreDataProperties.swift
//  
//
//  Created by LinhMAC on 03/01/2024.
//
//

import Foundation
import CoreData


extension FullResImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullResImageEntity> {
        return NSFetchRequest<FullResImageEntity>(entityName: "FullResImageEntity")
    }

    @NSManaged public var fullResAvatar: Data?

}
