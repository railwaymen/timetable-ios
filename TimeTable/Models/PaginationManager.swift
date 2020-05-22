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
        let tableHeightsToEndToStartFetchingNextPage = 1
        let cellsToEndToStartFetchingNextPage = self.cellsPerTableHeight * tableHeightsToEndToStartFetchingNextPage
        let cellToBeginFetching = allCellsCount - cellsToEndToStartFetchingNextPage
        guard cellToBeginFetching <= index else { return }
        self.fetchNextPageHandler()
    }
}
