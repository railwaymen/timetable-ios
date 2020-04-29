//
//  AccountingPeriodsViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol AccountingPeriodsViewModelOutput: class {
    func setUp()
    func showList()
    func showErrorView()
    func reloadData()
    func setActivityIndicator(isHidden: Bool)
}

protocol AccountingPeriodsViewModelType: class {
    func viewDidLoad()
    func numberOfRows(in section: Int) -> Int
    func configure(_ cell: AccountingPeriodsCellConfigurationInterface, for indexPath: IndexPath)
    func configure(_ errorView: ErrorViewable)
}

class AccountingPeriodsViewModel {
    private weak var userInterface: AccountingPeriodsViewModelOutput?
    private weak var coordinator: AccountingPeriodsCoordinatorViewModelInterface?
    private let apiClient: ApiClientAccountingPeriodsType
    private let errorHandler: ErrorHandlerType
    
    private let dateFormatter: DateFormatterType = DateFormatter.shortDate
    private let recordsPerPage: Int = 24
    private weak var errorViewModel: ErrorViewModelParentType?
    private var totalPages: Int?
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

// MARK: - AccountingPeriodsViewModelType
extension AccountingPeriodsViewModel: AccountingPeriodsViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp()
        self.fetchFirstPage()
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard section == 0 else { return 0 }
        return self.records.count
    }
    
    func configure(_ cell: AccountingPeriodsCellConfigurationInterface, for indexPath: IndexPath) {
        guard let record = self.record(at: indexPath) else { return }
        cell.configure(
            startsAt: self.formattedStartsAt(of: record),
            endsAt: self.formattedEndsAt(of: record),
            hours: "\(record.formattedCountedDuration)/\(record.duration.timerBigComponents.hours)",
            note: record.note ?? "",
            isFullTime: record.isFullTime,
            isClosed: record.isClosed)
    }
    
    func configure(_ errorView: ErrorViewable) {
        self.errorViewModel = self.coordinator?.configure(errorView, refreshHandler: {
            self.fetchFirstPage()
        })
    }
}

// MARK: - Private
extension AccountingPeriodsViewModel {
    private func fetchFirstPage() {
        let params = self.parameters(page: 1)
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.apiClient.fetchAccountingPeriods(parameters: params) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case let .success(response):
                self?.handleFetchSuccess(response: response)
            case let .failure(error):
                self?.handleFetchFailure(error: error)
            }
        }
    }
    
    private func parameters(page: Int) -> AccountingPeriodsParameters {
        AccountingPeriodsParameters(page: page, recordsPerPage: self.recordsPerPage)
    }
    
    private func handleFetchSuccess(response: AccountingPeriodsResponse) {
        self.totalPages = response.totalPages
        self.records = response.records
        self.userInterface?.showList()
    }
    
    private func handleFetchFailure(error: Error) {
        if let apiClientError = error as? ApiClientError {
            self.errorViewModel?.update(error: apiClientError)
        } else {
            self.errorViewModel?.update(error: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
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
}
