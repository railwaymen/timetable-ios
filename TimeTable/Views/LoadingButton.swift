//
//  LoadingButton.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

@IBDesignable class LoadingButton: AttributedButton {
    
    @IBInspectable let activityIndicatorColor: UIColor = .white
    @IBInspectable var disablesOnLoading: Bool = false
    
    private(set) var isLoading: Bool = false
    
    private var originalButtonText: String?
    private lazy var activityIndicator: UIActivityIndicatorView = self.createActivityIndicator()
    
    // MARK: - Internal
    func set(isLoading: Bool, animated: Bool = true) {
        isLoading ? self.showLoading(animated: animated) : self.hideLoading(animated: animated)
    }
    
    func showLoading(animated: Bool) {
        guard !self.isLoading else { return }
        self.isLoading = true
        self.originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        self.setTitle("", for: .disabled)
        self.showSpinning(animated: animated)
    }
    
    func hideLoading(animated: Bool) {
        guard self.isLoading else { return }
        defer { self.isLoading = false }
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
        if !self.contains(self.activityIndicator) {
            self.addActivityIndicatorToTheView()
        }
        self.activityIndicator.set(isAnimating: true, animated: animated)
        guard self.disablesOnLoading else { return }
        self.setWithAnimation(isEnabled: false, duration: 0.2)
    }
    
    private func addActivityIndicatorToTheView() {
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
