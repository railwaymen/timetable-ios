//
//  ServerConfigurationViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ServerConfigurationViewModelTests: XCTestCase {
    private let timeout = 0.1
    private var userInterface: UserInterfaceMock!
    private var coordinatorMock: CoordinatorMock!
    private var serverConfigurationManagerMock: ServerConfigurationManagerMock!
    private var errorHandler: ErrorHandlerMock!
    private var viewModel: ServerConfigurationViewModel!
    
    override func setUp() {
        userInterface = UserInterfaceMock()
        errorHandler = ErrorHandlerMock()
        coordinatorMock = CoordinatorMock()
        serverConfigurationManagerMock = ServerConfigurationManagerMock()
        viewModel = ServerConfigurationViewModel(userInterface: userInterface,
                                                 coordinator: coordinatorMock,
                                                 serverConfigurationManager: serverConfigurationManagerMock,
                                                 errorHandler: errorHandler)
        super.setUp()
    }
    
    func testViewDidLoadCallSetupViewOnTheUserInterface() {
        //Arrange
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterface.setupViewCalled)
        XCTAssertEqual(userInterface.setupViewStateValues.serverAddress, "")
        XCTAssertTrue(userInterface.setupViewStateValues.checkBoxIsActive)
    }
    
    func testViewWillAppearCallHideNavigationBarOnTheUserInterface() {
        //Arrange
        //Act
        viewModel.viewWillAppear()
        //Assert
        XCTAssertTrue(userInterface.hideNavigationBarCalled)
    }
    
    func testViewWillDesappearCallTearDownOnTheUserInterface() {
        //Arrange
        //Act
        viewModel.viewWillDisappear()
        //Assert
        XCTAssertTrue(userInterface.tearDownCalled)
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsNull() {
        //Arrange
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        switch errorHandler.throwedError as? UIError {
        case .cannotBeEmpty?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueThrowErrorWhileServerAddressIsInvalid() {
        //Arrange
        viewModel.serverAddressDidChange(text: "##invalid_address")
        //Act
        viewModel.viewRequestedToContinue()
        //Assert
        switch errorHandler.throwedError as? UIError {
        case .invalidFormat?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithDefaultValues() throws {
        //Arrange
        let verifyExepectation = self.expectation(description: "verifyExepectation")
        let mainQueueExpectation = self.expectation(description: "mainQueueExpectation")
        let hostString = "www.example.com"
        viewModel.serverAddressDidChange(text: hostString)
        serverConfigurationManagerMock.expectationHandler = verifyExepectation.fulfill
        
        //Act
        viewModel.viewRequestedToContinue()
        serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        wait(for: [verifyExepectation], timeout: timeout)
        
        //Assert
        DispatchQueue.main.async {
            do {
                let configuration = try self.coordinatorMock.serverConfigurationDidFinishValues.serverConfiguration.unwrap()
                XCTAssertEqual(configuration.host, try URL(string: hostString).unwrap())
                XCTAssertTrue(configuration.shouldRemeberHost)
            } catch {
                XCTFail()
            }
            mainQueueExpectation.fulfill()
        }
        wait(for: [mainQueueExpectation], timeout: timeout)
    }
    
    func testViewRequestedToContinueCreateCorrectServerConfigurationWithStaySigneInAsFalse() throws {
        //Arrange
        let verifyExepectation = self.expectation(description: "verifyExepectation")
        let mainQueueExpectation = self.expectation(description: "mainQueueExpectation")
        let hostString = "www.example.com"
        viewModel.serverAddressDidChange(text: hostString)
        viewModel.shouldRemeberHostCheckBoxStatusDidChange(isActive: true)
        serverConfigurationManagerMock.expectationHandler = verifyExepectation.fulfill
        
        //Act
        viewModel.viewRequestedToContinue()
        serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        wait(for: [verifyExepectation], timeout: timeout)

        //Assert
        DispatchQueue.main.async {
            do {
                let configuration = try self.coordinatorMock.serverConfigurationDidFinishValues.serverConfiguration.unwrap()
                XCTAssertEqual(configuration.host, try URL(string: hostString).unwrap())
                XCTAssertFalse(configuration.shouldRemeberHost)
            } catch {
                XCTFail()
            }
            mainQueueExpectation.fulfill()
        }
        wait(for: [mainQueueExpectation], timeout: timeout)
    }
    
    func testViewRequestedToContinueWithCorrectServerConfigurationCallCoordinator() throws {
        //Arrange
        let verifyExepectation = self.expectation(description: "verifyExepectation")
        let mainQueueExpectation = self.expectation(description: "mainQueueExpectation")
        let hostString = "www.example.com"
        viewModel.serverAddressDidChange(text: hostString)
        serverConfigurationManagerMock.expectationHandler = verifyExepectation.fulfill
        
        //Act
        viewModel.viewRequestedToContinue()
        serverConfigurationManagerMock.verifyConfigurationCompletion?(.success(Void()))
        wait(for: [verifyExepectation], timeout: timeout)

        //Assert
        DispatchQueue.main.async {
            XCTAssertTrue(self.coordinatorMock.serverConfigurationDidFinishValues.called)
            mainQueueExpectation.fulfill()
        }
        wait(for: [mainQueueExpectation], timeout: timeout)
    }
    
    func testViewRequestedToContinueWithInvalidServerConfigurationGetsAnError() throws {
        //Arrange
        let verifyExepectation = self.expectation(description: "")
        let hostString = "com"
        let url = try URL(string: hostString).unwrap()
        viewModel.serverAddressDidChange(text: hostString)
        serverConfigurationManagerMock.expectationHandler = verifyExepectation.fulfill
        //Act
        viewModel.viewRequestedToContinue()
        serverConfigurationManagerMock.verifyConfigurationCompletion?(.failure(ApiError.invalidHost(url)))
        wait(for: [verifyExepectation], timeout: timeout)
        //Assert
        XCTAssertNotNil(errorHandler.throwedError)
    }
    
    func testServerAddressDidChangePassedNilValue() {
        //Arrange
        //Act
        viewModel.serverAddressDidChange(text: nil)
        //Assert
        XCTAssertFalse(userInterface.continueButtonEnabledStateValues.called)
    }
    
    func testServerAddressDidChangePassedCorrectHostName() {
        //Arrange
        //Act
        viewModel.serverAddressDidChange(text: "www.example.com")
        //Assert
        XCTAssertTrue(userInterface.continueButtonEnabledStateValues.called)
        XCTAssertTrue(userInterface.continueButtonEnabledStateValues.isEnabled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnDissmissKeyboard() {
        //Arrange
        //Act
        _ = viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(userInterface.dissmissKeyboardCalled)
    }
    
    func testServerAddressTextFieldDidRequestedForReturnReturnCorrectValue() {
        //Arrange
        //Act
        let value = viewModel.serverAddressTextFieldDidRequestForReturn()
        //Assert
        XCTAssertTrue(value)
    }
    
    func testViewHasBeenTappedCallDissmissKeyboardOnUserInteface() {
        //Arrange
        //Act
        _ = viewModel.viewHasBeenTapped()
        //Assert
        XCTAssertTrue(userInterface.dissmissKeyboardCalled)
    }
}

private class ErrorHandlerMock: ErrorHandlerType {
    private(set) var throwedError: Error?
    private(set) var throwingFinallyBlock: ((Bool) -> Void)?
    private(set) var catchingErrorActionBlock: ((Error) throws -> Void)?
    
    func throwing(error: Error, finally: @escaping (Bool) -> Void) {
        throwedError = error
        throwingFinallyBlock = finally
    }
    
    func catchingError(action: @escaping (Error) throws -> Void) -> ErrorHandlerType {
        catchingErrorActionBlock = action
        return self
    }
}

private class UserInterfaceMock: ServerConfigurationViewModelOutput {
    private(set) var setupViewCalled = false
    private(set) var setupViewStateValues: (checkBoxIsActive: Bool, serverAddress: String) = (false, "")
    private(set) var tearDownCalled = false
    private(set) var hideNavigationBarCalled = false
    private(set) var dissmissKeyboardCalled = false
    private(set) var continueButtonEnabledStateValues: (called: Bool, isEnabled: Bool) = (false, false)
    private(set) var checkBoxIsActiveStateValues: (called: Bool, isActive: Bool) = (false, false)
    
    func setupView(checkBoxIsActive: Bool, serverAddress: String) {
        setupViewCalled = true
        setupViewStateValues = (checkBoxIsActive, serverAddress)
    }

    func tearDown() {
        tearDownCalled = true
    }
    
    func hideNavigationBar() {
        hideNavigationBarCalled = true
    }
    
    func dissmissKeyboard() {
        dissmissKeyboardCalled = true
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        continueButtonEnabledStateValues = (true, isEnabled)
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        checkBoxIsActiveStateValues = (true, isActive)
    }
}

private class CoordinatorMock: ServerConfigurationCoordinatorDelagete {
    private(set) var serverConfigurationDidFinishValues: (called: Bool, serverConfiguration: ServerConfiguration?) = (false, nil)
    
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration) {
        serverConfigurationDidFinishValues = (true, serverConfiguration)
    }
}

private class ServerConfigurationManagerMock: ServerConfigurationManagerType {
    
    var expectationHandler: (() -> Void)?
    var verifyConfigurationCompletion: ((Result<Void>) -> Void)?
    private(set) var configuration: ServerConfiguration?
    var oldConfiguration: ServerConfiguration?
    private(set) var getOldConfigurationCalled = false
    
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void>) -> Void)) {
        self.configuration = configuration
        self.verifyConfigurationCompletion = completion
        expectationHandler?()
    }
    
    func getOldConfiguration() -> ServerConfiguration? {
        getOldConfigurationCalled = true
        return oldConfiguration
    }
}
