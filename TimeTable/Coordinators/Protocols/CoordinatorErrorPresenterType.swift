//
//  CoordinatorErrorPresenterType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol CoordinatorErrorPresenterType: class {
    func present(error: Error)
}
