//
//  PaginationManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 22/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol PaginationManagerType: class {
    var recordsPerPage: Int { get }
    func tableViewWillDisplayCell(index: Int, allCellsCount: Int)
}

final class PaginationManager {
    private let tableHeightsPerPage: Int = 5
    private let cellsPerTableHeight: Int
    private let fetchNextPageHandler: () -> Void
    
    var recordsPerPage: Int {
        self.cellsPerTableHeight * self.tableHeightsPerPage
    }
    
    // MARK: - Initialization
    init(
        cellsPerTableHeight: Int,
        fetchNextPageHandler: @escaping () -> Void
    ) {
        self.cellsPerTableHeight = cellsPerTableHeight
        self.fetchNextPageHandler = fetchNextPageHandler
    }
}

// MARK: - PaginationManagerType
extension PaginationManager: PaginationManagerType {
    func tableViewWillDisplayCell(index: Int, allCellsCount: Int) {
        guard self.shouldFetchNextPage(cellIndex: index, allCellsCount: allCellsCount) else { return }
        self.fetchNextPageHandler()
    }
}

// MARK: - Private
extension PaginationManager {
    private func shouldFetchNextPage(cellIndex: Int, allCellsCount: Int) -> Bool {
        let maxTableHeightsCountFromEnd = 1
        let maxCellsCountFromEnd = self.cellsPerTableHeight * maxTableHeightsCountFromEnd
        let minIndex = allCellsCount - maxCellsCountFromEnd
        return cellIndex >= minIndex
    }
}
