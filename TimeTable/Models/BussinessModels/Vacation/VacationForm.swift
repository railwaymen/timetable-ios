//
//  VacationForm.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol VacationFormType {
    var startDate: Date { get set }
    var endDate: Date { get set }
    var type: VacationType { get set }
    var note: String? { get set }
    
    func validationErrors() -> [VacationForm.ValidationError]
    func convertToEncoder() throws -> VacationEncoder
}

struct VacationForm: VacationFormType {
    var startDate: Date
    var endDate: Date
    var type: VacationType
    var note: String?
    
    func validationErrors() -> [ValidationError] {
        guard self.type == .others else { return [] }
        guard note == nil else { return [] }
        return [.noteIsNil]
    }
    
    func convertToEncoder() throws -> VacationEncoder {
        let errors = self.validationErrors()
        if let first = errors.first {
            throw first
        }
        return VacationEncoder(type: self.type, note: self.note, startDate: self.startDate, endDate: self.endDate)
    }
}

// MARK: - Structures
extension VacationForm {
    enum ValidationError: Error, Equatable {
        case noteIsNil
    }
}
