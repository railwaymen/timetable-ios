//
//  VacationForm.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct VacationForm {
    var startDate: Date
    var endDate: Date
    var type: VacationType
    var note: String?
    
    func convertToEncoder() -> VacationEncoder {
        return VacationEncoder(type: self.type, description: self.note, startDate: self.startDate, endDate: self.endDate)
    }
}
