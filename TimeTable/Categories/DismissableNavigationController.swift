//
//  DismissableNavigationController.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 11/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

class DismissableNavigationController: UINavigationController {
    private var didDismissHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.presentationController?.delegate = self
    }
    
    // MARK: - Internal
    func setDidDismissHandler(_ handler: @escaping () -> Void) {
        self.didDismissHandler = handler
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension DismissableNavigationController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.didDismissHandler?()
    }
}
