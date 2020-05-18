//
//  UIScrollView+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 15/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol UIScrollViewType: class {
    var adjustedContentInset: UIEdgeInsets { get }
    var bounds: CGRect { get }
    var frame: CGRect { get }
    var contentSize: CGSize { get }
    var contentOffset: CGPoint { get }
    
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool)
    func contains(_ view: UIFocusEnvironment) -> Bool
    func viewEdgeYPosition(view: UIView, verticalPosition: UIScrollView.VerticalPosition) -> CGFloat
}

extension UIScrollViewType {
    var minYOffset: CGFloat {
        -self.adjustedContentInset.top
    }
    
    var maxYOffset: CGFloat {
        self.contentSize.height - self.bounds.height + self.adjustedContentInset.bottom
    }
    
    func adjustToContentOffsetBounds(yOffset: CGFloat) -> CGFloat {
        max(self.minYOffset, min(yOffset, self.maxYOffset))
    }
}

extension UIScrollView: UIScrollViewType {
    func viewEdgeYPosition(view: UIView, verticalPosition: VerticalPosition) -> CGFloat {
        let viewYPosition = view.convert(view.bounds, to: self).minY
        switch verticalPosition {
        case .top:
            return viewYPosition
        case .bottom:
            return viewYPosition + view.frame.height
        }
    }
}

// MARK: - Structures
extension UIScrollView {
    enum VerticalPosition {
        case top
        case bottom
    }
    
    final class ScrollAction {
        let scrollView: UIScrollViewType
        let contentOffset: CGPoint
        
        // MARK: - Initialization
        init(scrollView: UIScrollViewType) {
            self.scrollView = scrollView
            self.contentOffset = scrollView.contentOffset
        }
        
        private init(
            scrollView: UIScrollViewType,
            contentOffset: CGPoint
        ) {
            self.scrollView = scrollView
            self.contentOffset = contentOffset
        }
        
        // MARK: - Internal
        func scroll(
            to verticalPosition: VerticalPosition,
            of view: UIView,
            addingOffset offset: CGFloat = 0
        ) -> ScrollAction {
            guard self.scrollView.contains(view) else { return self }
            let viewEdgeYPosition: CGFloat = self.scrollView.viewEdgeYPosition(view: view, verticalPosition: verticalPosition)
            let visiblePartHeight: CGFloat = self.scrollView.bounds.height - self.scrollView.adjustedContentInset.vertical
            let minVisibleYPosition: CGFloat = self.contentOffset.y + self.scrollView.adjustedContentInset.top
            let maxVisibleYPosition: CGFloat = minVisibleYPosition + visiblePartHeight
            let expectedOffset: CGFloat = viewEdgeYPosition + offset
            let distanceToTop: CGFloat = abs(minVisibleYPosition.distance(to: expectedOffset))
            let distanceToBottom: CGFloat = abs(maxVisibleYPosition.distance(to: expectedOffset))
            let yOffset: CGFloat
            
            if minVisibleYPosition...maxVisibleYPosition ~= expectedOffset {
                return self
            } else if distanceToTop > distanceToBottom {
                yOffset = expectedOffset - visiblePartHeight
            } else {
                yOffset = expectedOffset - self.scrollView.adjustedContentInset.top
            }
            
            let newOffset = CGPoint(x: self.contentOffset.x, y: self.scrollView.adjustToContentOffsetBounds(yOffset: yOffset))
            return ScrollAction(scrollView: self.scrollView, contentOffset: newOffset)
        }
        
        func perform(animated: Bool) {
            self.scrollView.setContentOffset(self.contentOffset, animated: animated)
        }
    }
}

// MARK: - Internal
extension UIScrollView {
    func buildScrollAction() -> ScrollAction {
        ScrollAction(scrollView: self)
    }
}
