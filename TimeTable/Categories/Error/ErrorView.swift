//
//  ErrorView.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias ErrorViewable = ErrorViewType & ErrorViewModelOutput

protocol ErrorViewType: class {
    func configure(viewModel: ErrorViewModelType)
}

class ErrorView: UIView {
    private var view: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var refreshButton: UIButton!
    
    private var viewModel: ErrorViewModelType!
        
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    // MARK: - Actions
    @IBAction private func refreshButtonTapped(_ sender: UIButton) {
        self.viewModel.refreshButtonTapped()
    }
}

// MARK: - ErrorViewModelOutput
extension ErrorView: ErrorViewModelOutput {
    func setUp(refreshIsHidden: Bool) {
        self.refreshButton.isHidden = refreshIsHidden
    }
    
    func update(title: String) {
        self.titleLabel.text = title
    }
}

// MARK: - ErrorViewControllerType
extension ErrorView: ErrorViewType {
    func configure(viewModel: ErrorViewModelType) {
        self.viewModel = viewModel
        viewModel.viewDidConfigure()
    }
}

// MARK: - Private
private extension ErrorView {
    private func commonInit() {
        self.view = loadNib()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.view)
        
        self.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
