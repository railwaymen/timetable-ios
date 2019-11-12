//
//  ProjectUserViewTableViewCellMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ProjectUserViewTableViewCellMock: ProjectUserViewTableViewCellType {
    
    private(set) var configureName: String?
    func configure(withName name: String) {
        self.configureName = name
    }
}
