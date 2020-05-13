//
//  NewVacationValidationError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct NewVacationValidationError: Error, ValidationErrorType {
    let base: [BaseErrorKey]
    let description: [DescriptionErrorKey]
    let startDate: [StartDateErrorKey]
    let endDate: [EndDateErrorKey]
    let vacationType: [VacationTypeErrorKey]
    
    var isEmpty: Bool {
        return self.base.isEmpty
            && self.description.isEmpty
            && self.startDate.isEmpty
            && self.endDate.isEmpty
            && self.vacationType.isEmpty
    }
    
    private enum CodingKeys: String, CodingKey {
        case base
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case vacationType = "vacation_type"
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try? container.decode([BasicError<BaseErrorKey>].self, forKey: .base)
        self.base = base?.map(\.error) ?? []
        let description = try? container.decode([BasicError<DescriptionErrorKey>].self, forKey: .description)
        self.description = description?.map(\.error) ?? []
        let startDate = try? container.decode([BasicError<StartDateErrorKey>].self, forKey: .startDate)
        self.startDate = startDate?.map(\.error) ?? []
        let endDate = try? container.decode([BasicError<EndDateErrorKey>].self, forKey: .endDate)
        self.endDate = endDate?.map(\.error) ?? []
        let vacationType = try? container.decode([BasicError<VacationTypeErrorKey>].self, forKey: .vacationType)
        self.vacationType = vacationType?.map(\.error) ?? []
    }
}

// MARK: - Structures
extension NewVacationValidationError {
    enum BaseErrorKey: String, Decodable {
        case workTimeExists = "work_time_exists"
    }
    
    enum DescriptionErrorKey: String, Decodable {
        case blank
    }
    
    enum StartDateErrorKey: String, Decodable {
        case greaterThanEndDate = "greater_than_end_date"
        case blank
    }
    
    enum EndDateErrorKey: String, Decodable {
        case blank
    }
    
    enum VacationTypeErrorKey: String, Decodable {
        case blank
        case inclusion
    }
}

// MARK: - LocalizedDescribable
extension NewVacationValidationError: LocalizedDescribable {
    var localizedDescription: String {
        return self.localizedDescriptions.first ?? ""
    }
    
    private var localizedDescriptions: [String] {
        return self.base.map(\.localizedDescription) +
            self.description.map(\.localizedDescription) +
            self.startDate.map(\.localizedDescription) +
            self.endDate.map(\.localizedDescription) +
            self.vacationType.map(\.localizedDescription)
    }
}

extension NewVacationValidationError.BaseErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .workTimeExists: return R.string.localizable.newvacation_error_base_workTimeExists()
        }
    }
}

extension NewVacationValidationError.DescriptionErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .blank: return R.string.localizable.newvacation_error_description_blank()
        }
    }
}

extension NewVacationValidationError.StartDateErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .blank: return R.string.localizable.newvacation_error_startDate_blank()
        case .greaterThanEndDate: return R.string.localizable.newvacation_error_startDate_greaterThanEndDate()
        }
    }
}

extension NewVacationValidationError.EndDateErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .blank: return R.string.localizable.newvacation_error_endDate_blank()
        }
    }
}

extension NewVacationValidationError.VacationTypeErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .blank: return R.string.localizable.newvacation_error_vacationType_blank()
        case .inclusion: return R.string.localizable.newvacation_error_vacationType_inclusion()
        }
    }
}
