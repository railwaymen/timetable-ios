//
//  UIScrollViewMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 18/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIScrollViewMock {
    var adjustedContentInsetReturnValue: UIEdgeInsets = .zero
    
    var frameReturnValue: CGRect = .zero
    
    var contentSizeReturnValue: CGSize = .zero
    
    var contentOffsetReturnValue: CGPoint = .zero
    
    private(set) var setContentOffsetParams: [SetContentOffsetParams] = []
    struct SetContentOffsetParams {
        let contentOffset: CGPoint
        let animated: Bool
    }
    
    var containsReturnValue: Bool = true
    private(set) var containsParams: [ContainsParams] = []
    struct ContainsParams {
        let view: UIFocusEnvironment
    }
    
    var viewEdgeYPositionReturnValue: CGFloat = 0
    private(set) var viewEdgeYPositionParams: [ViewEdgeYPositionParams] = []
    struct ViewEdgeYPositionParams {
        let view: UIView
        let verticalPosition: UIScrollView.VerticalPosition
    }
}

// MARK: - UIScrollViewType
extension UIScrollViewMock: UIScrollViewType {
    var adjustedContentInset: UIEdgeInsets {
        self.adjustedContentInsetReturnValue
    }
    
    var bounds: CGRect {
        CGRect(origin: .zero, size: self.frame.size)
    }
    
    var frame: CGRect {
        self.frameReturnValue
    }
    
    var contentSize: CGSize {
        self.contentSizeReturnValue
    }
    
    var contentOffset: CGPoint {
        self.contentOffsetReturnValue
    }
    
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        self.setContentOffsetParams.append(SetContentOffsetParams(contentOffset: contentOffset, animated: animated))
    }
    
    func contains(_ view: UIFocusEnvironment) -> Bool {
        self.containsParams.append(ContainsParams(view: view))
        return self.containsReturnValue
    }
    
    func viewEdgeYPosition(view: UIView, verticalPosition: UIScrollView.VerticalPosition) -> CGFloat {
        self.viewEdgeYPositionParams.append(ViewEdgeYPositionParams(view: view, verticalPosition: verticalPosition))
        return self.viewEdgeYPositionReturnValue
    }
}

