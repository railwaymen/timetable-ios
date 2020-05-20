//
//  ApiClient+Typealiases.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

typealias ApiClientType =
    ApiClientSessionType
    & ApiClientWorkTimesType
    & ApiClientProjectsType
    & ApiClientUsersType
    & ApiClientAccountingPeriodsType
    & ApiClientVacationType
    & ApiClientRemoteWorkType

typealias TimeTableTabApiClientType =
    ApiClientWorkTimesType
    & ApiClientProjectsType
    & ApiClientUsersType
    & ApiClientAccountingPeriodsType

typealias WorkTimeApiClientType =
    ApiClientWorkTimesType
    & ApiClientProjectsType

typealias TimesheetApiClientType =
    ApiClientWorkTimesType
    & ApiClientAccountingPeriodsType
    & ApiClientProjectsType
