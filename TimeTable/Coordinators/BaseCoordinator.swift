//
//  BaseCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class Coordinator: CoordinatorType {
    
    var identifier: UUID = UUID()
    var children: [Coordinator: Any]
    var window: UIWindow?
    var finishCompletion: (() -> Void)?
    
    // MARK: - Initialization
    init(window: UIWindow?) {
        self.identifier = UUID()
        self.children = [:]
        self.window = window
    }
    
    // MARK: - CoordinatorType
    func start(finishCompletion: (() -> Void)?) {
        self.finishCompletion = finishCompletion
    }
    
    func finish() {
        finishCompletion?()
    }
    
    func addChildCoordinator(child: Coordinator) {
        children[child] = child
    }
    
    func removeChildCoordinator(child: Coordinator) {
        children[child] = nil
    }
}
