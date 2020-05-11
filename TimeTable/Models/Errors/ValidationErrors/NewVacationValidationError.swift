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
    
    private enum CodingKeys: String, CodingKey {
        case base
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case vacationType = "vacation_type"
    }
    
    var isEmpty: Bool {
        return self.base.isEmpty
            && self.description.isEmpty
            && self.startDate.isEmpty
            && self.endDate.isEmpty
            && self.vacationType.isEmpty
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

// MARK: - ValidationErrorUIRepresentable
extension NewVacationValidationError: ValidationErrorUIRepresentable {
    var uiErrors: [UIError] {
        return base.map(\.uiError) +
            description.map(\.uiError) +
            startDate.map(\.uiError) +
            endDate.map(\.uiError) +
            vacationType.map(\.uiError)
    }
}

// MARK: - UIErrorRepresentable
extension NewVacationValidationError.BaseErrorKey: UIErrorRepresentable {
    var uiError: UIError {
        switch self {
        case .workTimeExists: return UIError.newVacationBaseWorkTimeExists
        }
    }
}

extension NewVacationValidationError.DescriptionErrorKey: UIErrorRepresentable {
    var uiError: UIError {
        switch self {
        case .blank: return UIError.newVacationDescriptionBlank
        }
    }
}

extension NewVacationValidationError.StartDateErrorKey: UIErrorRepresentable {
    var uiError: UIError {
        switch self {
        case .blank: return UIError.newVacationStartDateBlank
        case .greaterThanEndDate: return UIError.newVacationStartDateGreaterThanEndDate
        }
    }
}

extension NewVacationValidationError.EndDateErrorKey: UIErrorRepresentable {
    var uiError: UIError {
        switch self {
        case .blank: return UIError.newVacationEndDateBlank
        }
    }
}

extension NewVacationValidationError.VacationTypeErrorKey: UIErrorRepresentable {
    var uiError: UIError {
        switch self {
        case .blank: return UIError.newVacationVacationTypeBlank
        case .inclusion: return UIError.newVacationVacationTypeInclusion
        }
    }
}
