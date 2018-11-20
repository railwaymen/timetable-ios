//
//  SessionEntity.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreData

@objc(UserEntity)
class UserEntity: NSManagedObject {
    @NSManaged var identifier: Int64
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var token: String
}
