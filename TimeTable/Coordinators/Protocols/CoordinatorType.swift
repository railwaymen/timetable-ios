//
//  CoordinatorType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol CoordinatorType: class, Hashable {
    
    associatedtype Coordinator: CoordinatorType
    var identifier: UUID { get }
    var children: [Coordinator: Any] { get }
    
    var window: UIWindow? { get }
    
    func start()
    func start(finishCompletion: (() -> Void)?)
    func finish()
    func addChildCoordinator(child: Coordinator)
    func removeChildCoordinator(child: Coordinator?)
}

// MARK: - CoordinatorType
extension CoordinatorType {
    func start() {
        start(finishCompletion: nil)
    }
    
    var hashValue: Int {
        return identifier.hashValue
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
