//
//  LoadingButton.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

@IBDesignable class LoadingButton: AttributedButton {
    
    /// This property should be set before showing an activity indicator because it is initialized only once
    @IBInspectable var activityIndicatorColor: UIColor = .white
    @IBInspectable var disablesOnLoading: Bool = true
    
    var isLoading: Bool {
        self.activityIndicator.isAnimating
    }
    
    private var originalButtonText: String?
    private lazy var activityIndicator: UIActivityIndicatorView = self.createActivityIndicator()
    
    // MARK: - Internal
    func set(isLoading: Bool, animated: Bool = true) {
        isLoading ? self.showLoading(animated: animated) : self.hideLoading(animated: animated)
    }
    
    func showLoading(animated: Bool) {
        guard !self.isLoading else { return }
        self.originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        self.setTitle("", for: .disabled)
        self.showSpinning(animated: animated)
    }
    
    func hideLoading(animated: Bool) {
        guard self.isLoading else { return }
        self.setTitle(self.originalButtonText, for: .normal)
        self.setTitle(self.originalButtonText, for: .disabled)
        self.activityIndicator.set(isAnimating: false, animated: animated)
        guard self.disablesOnLoading else { return }
        self.setWithAnimation(isEnabled: true, duration: 0.2)
    }
}

// MARK: - Private
extension LoadingButton {
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = self.activityIndicatorColor
        return activityIndicator
    }
    
    private func showSpinning(animated: Bool) {
        self.addActivityIndicatorToTheViewIfNeeded()
        self.activityIndicator.set(isAnimating: true, animated: animated)
        guard self.disablesOnLoading else { return }
        self.setWithAnimation(isEnabled: false, duration: 0.2)
    }
    
    private func addActivityIndicatorToTheViewIfNeeded() {
        guard !self.contains(self.activityIndicator) else { return }
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.activityIndicator)
        self.centerActivityIndicatorInButton()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = self.centerXAnchor.constraint(equalTo: self.activityIndicator.centerXAnchor)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = self.centerYAnchor.constraint(equalTo: self.activityIndicator.centerYAnchor)
        self.addConstraint(yCenterConstraint)
    }
}
