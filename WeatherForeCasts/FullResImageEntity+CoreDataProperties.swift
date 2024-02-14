//
//  FullResImageEntity+CoreDataProperties.swift
//  
//
//  Created by LinhMAC on 15/02/2024.
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
