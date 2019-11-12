//
//  Array+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Index) -> Element? {
        return (self.startIndex..<self.endIndex).contains(index) ? self[index] : nil
    }
}
