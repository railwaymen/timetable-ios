//
//  UIErrors.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum UIElement {
    case loginTextField
    case passwordTextField
    case projectTextField
    case dayTextField
    case taskNameTextField
    case taskUrlTextField
    case startsAtTextField
    case endsAtTextField
    case noteTextView
}

enum UIError: Error {
    case cannotBeEmpty(UIElement)
    case invalidFormat(UIElement)
    case workTimeGreaterThan
    case genericError
    case loginCredentialsInvalid
    case newVacationBaseWorkTimeExists
    case newVacationDescriptionBlank
    case newVacationStartDateBlank
    case newVacationStartDateGreaterThanEndDate
    case newVacationEndDateBlank
    case newVacationVacationTypeBlank
    case newVacationVacationTypeInclusion
    case remoteWorkStartsAtOvelap
    case remoteWorkStartsAtTooOld
    case remoteWorkStartsAtEmpty
    case remoteWorkStartsAtIncorrectHours
    case remoteWorkEndsAtEmpty
    
    var localizedDescription: String {
        switch self {
        case .cannotBeEmpty:
            return R.string.localizable.error_cannot_be_empty()
        case .invalidFormat:
            return R.string.localizable.error_invalid_format()
        case .workTimeGreaterThan:
            return R.string.localizable.worktimeform_error_greater_than()
        case .genericError:
            return R.string.localizable.error_something_went_wrong()
        case .loginCredentialsInvalid:
            return R.string.localizable.credential_error_credentials_invalid()
        case .newVacationBaseWorkTimeExists:
            return R.string.localizable.newvacation_base_workTimeExists()
        case .newVacationDescriptionBlank:
            return R.string.localizable.newvacation_description_blank()
        case .newVacationStartDateBlank:
            return R.string.localizable.newvacation_startDate_blank()
        case .newVacationStartDateGreaterThanEndDate:
            return R.string.localizable.newvacation_startDate_greaterThanEndDate()
        case .newVacationEndDateBlank:
            return R.string.localizable.newvacation_endDate_blank()
        case .newVacationVacationTypeBlank:
            return R.string.localizable.newvacation_vacationType_blank()
        case .newVacationVacationTypeInclusion:
            return R.string.localizable.newvacation_vacationType_inclusion()
        case .remoteWorkStartsAtOvelap:
            return R.string.localizable.remotework_startsAt_ovelap()
        case .remoteWorkStartsAtTooOld:
            return R.string.localizable.remotework_startsAt_tooOld()
        case .remoteWorkStartsAtEmpty:
            return R.string.localizable.remotework_startsAt_empty()
        case .remoteWorkStartsAtIncorrectHours:
            return R.string.localizable.remotework_startsAt_incorrectHours()
        case .remoteWorkEndsAtEmpty:
            return R.string.localizable.remotework_endsAt_empty()
        }
    }
}

// MARK: - Equatable
extension UIError: Equatable {}
