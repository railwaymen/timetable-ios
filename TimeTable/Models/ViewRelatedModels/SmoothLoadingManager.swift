//
//  SmoothLoadingManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 21/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol SmoothLoadingManagerType: class {
    func showActivityIndicatorWithDelay()
    func hideActivityIndicator()
}

class SmoothLoadingManager {
    typealias ActivityIndicatorHandlerType = (_ isAnimating: Bool) -> Void
    
    private var timer: Timer?
    
    var activityIndicatorHandler: ActivityIndicatorHandlerType
    
    // MARK: - Initialization
    init(activityIndicatorHandler: @escaping ActivityIndicatorHandlerType) {
        self.activityIndicatorHandler = activityIndicatorHandler
    }
}

// MARK: - SmoothLoadingManagerType
extension SmoothLoadingManager: SmoothLoadingManagerType {
    func showActivityIndicatorWithDelay() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [activityIndicatorHandler] _ in
            activityIndicatorHandler(true)
        })
    }
    
    func hideActivityIndicator() {
        self.timer?.invalidate()
        self.activityIndicatorHandler(false)
    }
}
