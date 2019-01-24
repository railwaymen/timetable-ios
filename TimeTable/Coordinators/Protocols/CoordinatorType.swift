//
//  CoordinatorType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol CoordinatorType: class, Equatable {
    
    associatedtype Coordinator: CoordinatorType
    var children: [Coordinator] { get }
    
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
}
// MARK: - Equatable
extension CoordinatorType {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.children == rhs.children
    }
}
