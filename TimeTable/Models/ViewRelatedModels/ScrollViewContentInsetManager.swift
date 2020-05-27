//
//  ScrollViewContentInsetManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

final class ScrollViewContentInsetManager {
    private let view: UIView
    private let scrollView: UIScrollView
    
    // MARK: - Initialization
    init(view: UIView, scrollView: UIScrollView) {
        self.view = view
        self.scrollView = scrollView
    }
    
    // MARK: - Internal
    func updateBottomInset(keyboardState: KeyboardManager.KeyboardState) {
        let bottomSpace = self.view.frame.maxY - self.scrollView.frame.maxY
        let inset = max(0, keyboardState.keyboardHeight - bottomSpace - self.scrollView.safeAreaInsets.bottom)
        self.scrollView.contentInset.bottom = inset
        self.scrollView.verticalScrollIndicatorInsets.bottom = inset
    }
    
    func updateTopInset(keyboardState: KeyboardManager.KeyboardState) {
        guard let containerView = self.scrollView.subviews.first else { return }
        let systemTopPadding = self.scrollView.safeAreaInsets.top
        let centerY = self.view.frame.midY
        let maxYInset = centerY - containerView.frame.height / 2 - systemTopPadding
        switch keyboardState {
        case let .shown(keyboardHeight):
            let visibleContentHeight = self.scrollView.frame.height - systemTopPadding - keyboardHeight
            let topContentInset = max(0, visibleContentHeight - containerView.frame.height)
            self.scrollView.contentInset.top = min(topContentInset, maxYInset)
        case .hidden:
            self.scrollView.contentInset.top = maxYInset
        }
    }
}
