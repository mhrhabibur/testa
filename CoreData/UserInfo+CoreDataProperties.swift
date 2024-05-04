//
//  UserInfo+CoreDataProperties.swift
//  
//
//  Created by Habibur Rahman on 04-05-2024.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var gender: String?
    @NSManaged public var gardian: String?
    @NSManaged public var password: String?

}
