//
//  ViewControllerBuilderMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 02/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ViewControllerBuilderMock {
    
    // MARK: - ViewControllerBuilderType
    var serverConfigurationThrownError: Error?
    var serverConfigurationReturnValue: ServerConfigurationViewControllerable = ServerConfigurationViewControllerMock()
    private(set) var serverConfigurationParams: [ServerConfigurationParams] = []
    struct ServerConfigurationParams {}
    
    var loginThrownError: Error?
    var loginReturnValue: LoginViewControllerable = LoginViewControllerMock()
    private(set) var loginParams: [LoginParams] = []
    struct LoginParams {}
    
    var projectsThrownError: Error?
    var projectsReturnValue: ProjectsViewControllerable = ProjectsViewControllerMock()
    private(set) var projectsParams: [ProjectsParams] = []
    struct ProjectsParams {}
    
    var timesheetThrownError: Error?
    var timesheetReturnValue: TimesheetViewControllerable = TimesheetViewControllerMock()
    private(set) var timesheetParams: [TimesheetParams] = []
    struct TimesheetParams {}
    
    var workTimeContainerThrownError: Error?
    var workTimeContainerReturnValue: WorkTimeContainerViewControllerable!
    private(set) var workTimeContainerParams: [WorkTimeContainerParams] = []
    struct WorkTimeContainerParams {}
    
    var projectPickerReturnValue: ProjectPickerViewControllerable = ProjectPickerViewControllerMock()
    private(set) var projectPickerParams: [ProjectPickerParams] = []
    struct ProjectPickerParams {}
    
    var taskHistoryThrownError: Error?
    var taskHistoryReturnValue: TaskHistoryViewControllerable = TaskHistoryViewControllerMock()
    private(set) var taskHistoryParams: [TaskHistoryParams] = []
    struct TaskHistoryParams {}
    
    var profileThrownError: Error?
    var profileReturnValue: ProfileViewControllerable = ProfileViewControllerMock()
    private(set) var profileParams: [ProfileParams] = []
    struct ProfileParams {}
    
    var accountingPeriodsThrownError: Error?
    var accountingPeriodsReturnValue: AccountingPeriodsViewControllerable = AccountingPeriodsViewControllerMock()
    private(set) var accountingPeriodsParams: [AccountingPeriodsParams] = []
    struct AccountingPeriodsParams {}

    var vacationThrownError: Error?
    var vacationReturnValue: VacationViewControllerable = VacationViewControllerMock()
    private(set) var vacationParams: [VacationParams] = []
    struct VacationParams {}
    
    var newVacationThrownError: Error?
    var newVacationReturnValue: NewVacationViewControllerable = NewVacationViewControllerMock()
    private(set) var newVacationParams: [NewVacationParams] = []
    struct NewVacationParams {}
    
    var usedVacationThrownError: Error?
    var usedVacationReturnValue: UsedVacationViewControllerable = UsedVacationViewControllerMock()
    private(set) var usedVacationParams: [UsedVacationParams] = []
    struct UsedVacationParams {}
    
    private(set) var remoteWorkParams: [RemoteWorkParams] = []
    struct RemoteWorkParams {}
    var remoteWorkThrownError: Error?
    var remoteWorkReturnValue: RemoteWorkViewControllerable = RemoteWorkViewControllerMock()
    
    private(set) var registerRemoteWorkParams: [RegisterRemoteWorkParams] = []
    struct RegisterRemoteWorkParams {}
    var registerRemoteWorkThrownError: Error?
    var registerRemoteWorkReturnValue: RegisterRemoteWorkViewControllerable = RegisterRemoteWorkViewControllerMock()
}

// MARK: - ViewControllerBuilderType
extension ViewControllerBuilderMock: ViewControllerBuilderType {
    func serverConfiguration() throws -> ServerConfigurationViewControllerable {
        self.serverConfigurationParams.append(ServerConfigurationParams())
        if let error = self.serverConfigurationThrownError {
            throw error
        }
        return self.serverConfigurationReturnValue
    }
    
    func login() throws -> LoginViewControllerable {
        self.loginParams.append(LoginParams())
        if let error = self.loginThrownError {
            throw error
        }
        return self.loginReturnValue
    }
    
    func projects() throws -> ProjectsViewControllerable {
        self.projectsParams.append(ProjectsParams())
        if let error = self.projectsThrownError {
            throw error
        }
        return self.projectsReturnValue
    }
    
    func timesheet() throws -> TimesheetViewControllerable {
        self.timesheetParams.append(TimesheetParams())
        if let error = self.timesheetThrownError {
            throw error
        }
        return self.timesheetReturnValue
    }
    
    func workTimeContainer() throws -> WorkTimeContainerViewControllerable {
        self.workTimeContainerParams.append(WorkTimeContainerParams())
        if let error = self.workTimeContainerThrownError {
            throw error
        }
        return self.workTimeContainerReturnValue
    }
    
    func projectPicker() -> ProjectPickerViewControllerable {
        self.projectPickerParams.append(ProjectPickerParams())
        return self.projectPickerReturnValue
    }
    
    func taskHistory() throws -> TaskHistoryViewControllerable {
        self.taskHistoryParams.append(TaskHistoryParams())
        if let error = self.taskHistoryThrownError {
            throw error
        }
        return self.taskHistoryReturnValue
    }
    
    func profile() throws -> ProfileViewControllerable {
        self.profileParams.append(ProfileParams())
        if let error = self.profileThrownError {
            throw error
        }
        return self.profileReturnValue
    }
    
    func accountingPeriods() throws -> AccountingPeriodsViewControllerable {
        self.accountingPeriodsParams.append(AccountingPeriodsParams())
        if let error = self.accountingPeriodsThrownError {
            throw error
        }
        return self.accountingPeriodsReturnValue
    }
    
    func vacation() throws -> VacationViewControllerable {
        self.vacationParams.append(VacationParams())
        if let error = self.vacationThrownError {
            throw error
        }
        return self.vacationReturnValue
    }
    
    func newVacation() throws -> NewVacationViewControllerable {
        self.newVacationParams.append(NewVacationParams())
        if let error = self.newVacationThrownError {
            throw error
        }
        return self.newVacationReturnValue
    }
    
    func usedVacation() throws -> UsedVacationViewControllerable {
        self.usedVacationParams.append(UsedVacationParams())
        if let error = self.usedVacationThrownError {
            throw error
        }
        return self.usedVacationReturnValue
    }
    
    func remoteWork() throws -> RemoteWorkViewControllerable {
        self.remoteWorkParams.append(RemoteWorkParams())
        if let error = self.remoteWorkThrownError {
            throw error
        }
        return self.remoteWorkReturnValue
    }
    
    func registerRemoteWork() throws -> RegisterRemoteWorkViewControllerable {
        self.registerRemoteWorkParams.append(RegisterRemoteWorkParams())
        if let error = self.registerRemoteWorkThrownError {
            throw error
        }
        return self.registerRemoteWorkReturnValue
    }
}
