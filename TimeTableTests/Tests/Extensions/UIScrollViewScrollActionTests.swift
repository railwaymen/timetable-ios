//
//  UIScrollViewScrollActionTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 18/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIScrollViewScrollActionTests: XCTestCase {
    private var scrollView: UIScrollViewMock!
    
    override func setUp() {
        super.setUp()
        self.scrollView = UIScrollViewMock()
    }
}

// MARK: - scroll(to:of:addingOffset:)
extension UIScrollViewScrollActionTests {
    func testScroll_zeroInset_withObjectInVisibleRange() {
        //Arrange
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.viewEdgeYPositionReturnValue = 590
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 0)
        //Assert
        XCTAssertEqual(object.contentOffset.y, 0)
    }
    
    func testScroll_zeroInset_withObjectBelowVisibleRange() {
        //Arrange
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.viewEdgeYPositionReturnValue = 610
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 0)
        //Assert
        XCTAssertEqual(object.contentOffset.y, 10)
    }
    
    func testScroll_zeroInset_withObjectAboveVisibleRange() {
        //Arrange
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: 600)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.viewEdgeYPositionReturnValue = 10
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 0)
        //Assert
        XCTAssertEqual(object.contentOffset.y, 10)
    }
    
    func testScroll_withVerticalInset_withObjectInVisibleRange() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: -topInset)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 300
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 0)
        //Assert
        XCTAssertEqual(object.contentOffset.y, -topInset)
    }
    
    func testScroll_withVerticalInset_withObjectBelowVisibleRange() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: -topInset)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 400
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 0)
        //Assert
        XCTAssertEqual(object.contentOffset.y, 100)
    }
    
    func testScroll_withVerticalInset_withObjectAboveVisibleRange() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: 600)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 10
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 0)
        //Assert
        XCTAssertEqual(object.contentOffset.y, -90)
    }
    
    func testScroll_withVerticalInset_withOffset_withObjectInVisibleRange() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: -topInset)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 200
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 100)
        //Assert
        XCTAssertEqual(object.contentOffset.y, -topInset)
    }
    
    func testScroll_withVerticalInset_withOffset_withObjectBelowVisibleRange() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: -topInset)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 400
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 100)
        //Assert
        XCTAssertEqual(object.contentOffset.y, 200)
    }
    
    func testScroll_withVerticalInset_withOffset_withObjectOffsetBelowVisibleRange() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: -topInset)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 300
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: 100)
        //Assert
        XCTAssertEqual(object.contentOffset.y, 100)
    }
    
    func testScroll_withVerticalInset_withOffset_withObjectAboveVisibleRange() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: 600)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 110
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: -100)
        //Assert
        XCTAssertEqual(object.contentOffset.y, -90)
    }
    
    func testScroll_withVerticalInset_withOffset_withObjectPaddingAboveVisibleRange() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: 600)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 800
        //Act
        let object = sut.scroll(to: .bottom, of: UIView(), addingOffset: -100)
        //Assert
        XCTAssertEqual(object.contentOffset.y, 600)
    }
    
    func testScroll_chaining() {
        //Arrange
        let topInset: CGFloat = 100
        let bottomInset: CGFloat = 200
        self.scrollView.contentOffsetReturnValue = CGPoint(x: 0, y: -topInset)
        let sut = self.buildSUT()
        self.scrollView.frameReturnValue = self.buildFrame(width: 300, height: 600)
        self.scrollView.contentSizeReturnValue = CGSize(width: 300, height: 1200)
        self.scrollView.adjustedContentInsetReturnValue = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 600 // Below visible range
        //Act
        let object1 = sut.scroll(to: .bottom, of: UIView(), addingOffset: 0)
        self.scrollView.viewEdgeYPositionReturnValue = 30 // Above visible range
        let object2 = object1.scroll(to: .bottom, of: UIView(), addingOffset: 70)
        self.scrollView.viewEdgeYPositionReturnValue = 200 // In visible range
        let object3 = object2.scroll(to: .bottom, of: UIView(), addingOffset: 200)
        //Assert
        XCTAssertEqual(object1.contentOffset.y, 300)
        XCTAssertEqual(object2.contentOffset.y, 0)
        XCTAssertEqual(object3.contentOffset.y, 0)
    }
}

// MARK: - Private
extension UIScrollViewScrollActionTests {
    private func buildSUT() -> UIScrollView.ScrollAction {
        UIScrollView.ScrollAction(scrollView: self.scrollView)
    }
    
    private func buildFrame(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat, height: CGFloat) -> CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }
}
