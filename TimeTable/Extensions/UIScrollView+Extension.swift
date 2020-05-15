//
//  UIScrollView+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 15/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

// MARK: - Getters
extension UIScrollView {
    var minYOffset: CGFloat {
        -self.adjustedContentInset.top
    }
    
    var maxYOffset: CGFloat {
        self.contentSize.height - self.bounds.height + self.adjustedContentInset.bottom
    }
}

// MARK: - Structures
extension UIScrollView {
    enum VerticalPosition {
        case top
        case bottom
    }
    
    enum OffsetAdjustingMode {
        case exact
        case minimumMovement
        
        func calculatedOffset(currentOffset: CGFloat, expectedOffset: CGFloat) -> CGFloat {
            switch self {
            case .exact:
                return expectedOffset
            case .minimumMovement:
                return max(currentOffset, expectedOffset)
            }
        }
    }
}

// MARK: - Internal
extension UIScrollView {
    func scrollTo(
        _ verticalPosition: VerticalPosition,
        of view: UIView,
        addingOffset padding: CGFloat = 0,
        adjustingMode: OffsetAdjustingMode = .minimumMovement
    ) {
        guard self.contains(view) else { return }
        let overlappingHeight = self.contentInset.bottom
        let viewEdgeYPosition = self.viewEdgeYPosition(view: view, verticalPosition: verticalPosition)
        let expectedOffset = viewEdgeYPosition + padding - self.bounds.height + overlappingHeight
        let yOffset = adjustingMode.calculatedOffset(currentOffset: self.contentOffset.y, expectedOffset: expectedOffset)
        let newOffset = CGPoint(x: self.contentOffset.x, y: self.adjustToContentOffsetBounds(yOffset: yOffset))
        self.setContentOffset(newOffset, animated: true)
    }
}

// MARK: - Private
extension UIScrollView {
    private func viewEdgeYPosition(view: UIView, verticalPosition: VerticalPosition) -> CGFloat {
        let viewYPosition = view.convert(view.bounds, to: self).minY
        switch verticalPosition {
        case .top:
            return viewYPosition
        case .bottom:
            return viewYPosition + view.frame.height
        }
    }
    
    private func adjustToContentOffsetBounds(yOffset: CGFloat) -> CGFloat {
        max(self.minYOffset, min(yOffset, self.maxYOffset))
    }
}
