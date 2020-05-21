//
//  ContainerViewControllerType.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 21/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol ContainerViewControllerType: class {
    var containedViews: [UIView] { get }
}

extension ContainerViewControllerType {
    var currentlyVisibleView: UIView? {
        self.containedViews.first { !$0.isHidden }
    }
    
    func showWithAnimation(view: UIView, duration: TimeInterval) {
        guard self.containedViews.contains(view) else {
            assertionFailure("View to show should exist in containedViews")
            return
        }
        guard view.isHidden else { return }
        let options: UIView.AnimationOptions = [.showHideTransitionViews, .transitionCrossDissolve]
        if let previousView = self.currentlyVisibleView {
            UIView.transition(
                from: previousView,
                to: view,
                duration: duration,
                options: options)
        } else {
            UIView.transition(
                with: view,
                duration: duration,
                options: options,
                animations: {
                    view.set(isHidden: false)
            })
        }
    }
    
    func hideAllContainedViews() {
        self.containedViews.forEach {
            $0.set(isHidden: true)
        }
    }
}
