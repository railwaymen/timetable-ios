//
//  DefaultUITestCase.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 26/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest

class DefaultUITestCase: XCTestCase {
    
    // MARK: - Static
    static let server = MockServer()
    
    override class func setUp() {
        super.setUp()
        try? self.server.start()
    }
    
    override class func tearDown() {
        self.server.stop()
        super.tearDown()
    }
    
    // MARK: - Instance
    var app: XCUIApplication!
    
    var screenToTest: ScreenToTest {
        .serverConfiguration
    }
    
    // MARK: - Overridden
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        XCTAssert(Self.server.isRunning, "Server is not running")
        XCTAssertNoThrow(try Self.server.setUpDefaultResponses(), "Couldn't set default response: \(error)")
        self.app = XCUIApplication()
        self.app.setServerURL(Self.server.baseURL)
        self.app.setScreenToTest(self.screenToTest)
        self.app.launch()
        
        let elements = self.getElements(ofType: self.screenToTest.elementsType)
        XCTAssert(
            elements.waitToAppear(timeout: self.defaultTimeout),
            "Proper screen didn't load properly: \(self.screenToTest)")
    }
    
    // MARK: - Internal
    func getElements(ofType type: UIElements.Type) -> UIElements {
        return type.init(app: self.app)
    }
    
    func getElements<Elements: UIElements>(ofType type: Elements.Type = Elements.self) -> Elements {
        return type.init(app: self.app)
    }
}
