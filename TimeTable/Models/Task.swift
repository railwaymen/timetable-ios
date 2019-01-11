//
//  Task.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 11/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct Task {
    var project: ProjectType
    var title: String
    var url: URL?
    var fromDate: Date?
    var toDate: Date?
    
    private struct AutofillHours {
        private static let seconds = 60
        private static let minutes = 60
        static var lunchTimeInterval: TimeInterval {
            return TimeInterval(AutofillHours.seconds * 30)
        }
        static  var autofillTimeInterval: TimeInterval {
            return TimeInterval(AutofillHours.seconds * AutofillHours.minutes * 8)
        }
    }
    
    enum ProjectType {
        case none
        case some(ProjectDecoder)
        
        enum ProjectType {
            case standard
            case lunch(TimeInterval)
            case fullDay(TimeInterval)
        }
        
        var title: String {
            switch self {
            case .none:
                return "element.button.select_project".localized
            case .some(let project):
                return project.name
            }
        }
        
        var allowsTask: Bool {
            switch self {
            case .none:
                return true
            case .some(let project):
                return project.workTimesAllowsTask
            }
        }
        
        var type: ProjectType? {
            switch self {
            case .none:
                return nil
            case .some(let project):
                if let autofill = project.autofill, autofill {
                    return .fullDay(AutofillHours.autofillTimeInterval)
                } else if project.isLunch {
                    return .lunch(AutofillHours.lunchTimeInterval)
                }
                return .standard
            }
        }
    }
}
