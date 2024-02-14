//
//  ProfileEntity+CoreDataProperties.swift
//  
//
//  Created by LinhMAC on 15/02/2024.
//
//

import Foundation
import CoreData


extension ProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?

}
