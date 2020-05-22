//
//  AccountingPeriodsViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol AccountingPeriodsViewModelOutput: class {
    func setUp()
    func showList()
    func showErrorView()
    func reloadData()
    func setActivityIndicator(isAnimating: Bool)
    func setBottomContentInset(isHidden: Bool)
    func getMaxCellsPerPage() -> Int
}

protocol AccountingPeriodsViewModelType: class {
    func viewDidLoad()
    func viewWillAppear()
    func numberOfRows(in section: Int) -> Int
    func configure(_ cell: AccountingPeriodsCellConfigurationInterface, for indexPath: IndexPath)
    func configure(_ errorView: ErrorViewable)
    func viewWillDisplayCell(at indexPath: IndexPath)
}

class AccountingPeriodsViewModel {
    private weak var userInterface: AccountingPeriodsViewModelOutput?
    private weak var coordinator: AccountingPeriodsCoordinatorViewModelInterface?
    private let apiClient: ApiClientAccountingPeriodsType
    private let errorHandler: ErrorHandlerType
    
    private let dateFormatter: DateFormatterType = DateFormatter.shortDate
    private var recordsPerPage: Int = 24
    private weak var errorViewModel: ErrorViewModelParentType?
    private var totalPages: Int?
    private var state: State?
    private var records: [AccountingPeriod] = [] {
        didSet {
            self.userInterface?.reloadData()
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: AccountingPeriodsViewModelOutput,
        coordinator: AccountingPeriodsCoordinatorViewModelInterface?,
        apiClient: ApiClientAccountingPeriodsType,
        errorHandler: ErrorHandlerType
     ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
    }
}

// MARK: - Structures
extension AccountingPeriodsViewModel {
    enum State: Equatable {
        case failedFetchingFirstPage
        case fetching(page: Int)
        case fetched(page: Int)
    }
}

// MARK: - AccountingPeriodsViewModelType
extension AccountingPeriodsViewModel: AccountingPeriodsViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp()
    }
    
    func viewWillAppear() {
        guard self.state == nil else { return }
        self.setUpRecordsNumberPerPage()
        self.fetchFirstPage()
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard section == 0 else { return 0 }
        return self.records.count
    }
    
    func configure(_ cell: AccountingPeriodsCellConfigurationInterface, for indexPath: IndexPath) {
        guard let record = self.record(at: indexPath) else { return }
        let config = AccountingPeriodsCell.Config(
            startsAt: self.formattedStartsAt(of: record),
            endsAt: self.formattedEndsAt(of: record),
            hours: "\(record.formattedCountedDuration)/\(record.formattedDuration)",
            hoursColor: self.color(for: record),
            note: record.note ?? "",
            isFullTime: record.isFullTime,
            isClosed: record.isClosed)
        cell.configure(with: config)
    }
    
    func configure(_ errorView: ErrorViewable) {
        self.errorViewModel = self.coordinator?.configure(errorView, refreshHandler: {
            self.fetchFirstPage()
        })
    }
    
    func viewWillDisplayCell(at indexPath: IndexPath) {
        let cellsToTheEndToBeginFetchingOfTheNextPage: Int = 6
        let cellToBeginFetching = self.records.count - cellsToTheEndToBeginFetchingOfTheNextPage
        guard cellToBeginFetching <= indexPath.row else { return }
        self.fetchNextPage()
    }
}

// MARK: - Private
extension AccountingPeriodsViewModel {
    private func setUpRecordsNumberPerPage() {
        guard let cellsPerPage = self.userInterface?.getMaxCellsPerPage() else { return }
        self.recordsPerPage = cellsPerPage * 2
    }
    
    private func fetchFirstPage() {
        guard self.state == nil || self.state == .failedFetchingFirstPage else { return }
        self.state = .fetching(page: 1)
        let params = self.parameters(page: 1)
        self.userInterface?.setActivityIndicator(isAnimating: true)
        self.apiClient.fetchAccountingPeriods(parameters: params) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isAnimating: false)
            switch result {
            case let .success(response):
                self?.handleFirstFetchSuccess(response: response)
            case let .failure(error):
                self?.handleFirstFetchFailure(error: error)
            }
        }
    }
    
    private func handleFirstFetchSuccess(response: AccountingPeriodsResponse) {
        self.totalPages = response.totalPages
        self.records = response.records
        self.state = .fetched(page: 1)
        self.userInterface?.showList()
    }
    
    private func handleFirstFetchFailure(error: Error) {
        if let apiClientError = error as? ApiClientError {
            self.errorViewModel?.update(localizedError: apiClientError)
        } else {
            self.errorViewModel?.update(localizedError: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.state = .failedFetchingFirstPage
        self.userInterface?.showErrorView()
    }
    
    private func fetchNextPage() {
        guard case let .fetched(lastFetchedPage) = self.state else { return }
        guard let totalPages = self.totalPages,
            lastFetchedPage < totalPages else { return }
        let nextPage = lastFetchedPage + 1
        self.state = .fetching(page: nextPage)
        let parameters = self.parameters(page: nextPage)
        self.apiClient.fetchAccountingPeriods(parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.records += response.records
                self.state = .fetched(page: nextPage)
                guard nextPage == totalPages else { break }
                self.userInterface?.setBottomContentInset(isHidden: true)
            case let .failure(error):
                self.state = .fetched(page: lastFetchedPage)
                guard !(error is ApiClientError) else { break }
                self.errorHandler.throwing(error: error)
            }
        }
    }
    
    private func parameters(page: Int) -> AccountingPeriodsParameters {
        AccountingPeriodsParameters(page: page, recordsPerPage: self.recordsPerPage)
    }
    
    private func record(at indexPath: IndexPath) -> AccountingPeriod? {
        guard indexPath.section == 0 else { return nil }
        return self.records[safeIndex: indexPath.row]
    }
    
    private func formattedStartsAt(of record: AccountingPeriod) -> String {
        guard let startsAtDate = record.startsAt else { return "" }
        return self.dateFormatter.string(from: startsAtDate)
    }
    
    private func formattedEndsAt(of record: AccountingPeriod) -> String {
        guard let endsAtDate = record.endsAt else { return "" }
        return self.dateFormatter.string(from: endsAtDate)
    }
    
    private func color(for record: AccountingPeriod) -> UIColor {
        if record.countedDuration < record.duration {
            return .tint
        } else if record.countedDuration == record.duration {
            return .defaultLabel
        } else {
            return .accountingPeriods
        }
    }
}
