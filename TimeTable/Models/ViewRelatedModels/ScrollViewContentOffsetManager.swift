//
//  ScrollViewContentOffsetManager.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

final class ScrollViewContentOffsetManager {
    var scrollView: UIScrollView
    var viewsOrder: [UIView]
    var focusedView: UIView? {
        didSet {
            self.setContentOffset(animated: true)
        }
    }
    
    private let bottomPadding: CGFloat
    
    // MARK: - Initialization
    init(
        scrollView: UIScrollView,
        focusedView: UIView? = nil,
        viewsOrder: [UIView],
        bottomPadding: CGFloat
    ) {
        self.scrollView = scrollView
        self.focusedView = focusedView
        self.viewsOrder = viewsOrder
        self.bottomPadding = bottomPadding
    }
    
    // MARK: - Internal
    func setContentOffset(animated: Bool) {
        guard let currentView = self.focusedView else { return }
        guard let nextView = self.getViewUnderFocusedView() else { return }
        DispatchQueue.main.async {
            self.scrollView.layoutIfNeeded()
            if let textView = currentView as? UITextView,
                let selectedRange = textView.selectedTextRange {
                let cursorYPosition = min(textView.firstRect(for: selectedRange).minY, textView.bounds.maxY)
                self.scrollView.buildScrollAction()
                    .scroll(to: .top, of: currentView, addingOffset: -32)
                    .scroll(to: .bottom, of: nextView, addingOffset: self.bottomPadding)
                    .scroll(to: .top, of: currentView, addingOffset: cursorYPosition - self.bottomPadding)
                    .perform(animated: animated)
            } else {
                self.scrollView.buildScrollAction()
                    .scroll(to: .bottom, of: nextView, addingOffset: self.bottomPadding)
                    .scroll(to: .top, of: currentView, addingOffset: -32)
                    .perform(animated: animated)
            }
        }
    }
}

// MARK: - Private
extension ScrollViewContentOffsetManager {
    private func getViewUnderFocusedView() -> UIView? {
        guard let focusedView = self.focusedView else { return nil }
        guard let focusedViewIndex = self.viewsOrder.firstIndex(of: focusedView) else { return nil }
        return self.viewsOrder[safeIndex: focusedViewIndex + 1]
    }
}
