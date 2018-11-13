//
//  UserEntity+SessionDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 13/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreStore

protocol UserEntityTranslatorType: class {
    static func createUser(from userDecoder: SessionDecoder, transaction: AsynchronousDataTransactionType) -> UserEntity
}

extension UserEntity: UserEntityTranslatorType {
    static func createUser(from userDecoder: SessionDecoder, transaction: AsynchronousDataTransactionType) -> UserEntity {
        let user = transaction.create(Into<UserEntity>())
        user.firstName = userDecoder.firstName
        user.lastName = userDecoder.lastName
        user.token = userDecoder.token
        user.identifier = Int64(userDecoder.identifier)
        return user
    }
}
