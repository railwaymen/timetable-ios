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
        viewModel.refreshButtonTapped()
    }
}

// MARK: - ErrorViewModelOutput
extension ErrorView: ErrorViewModelOutput {
    func setUp(refreshIsHidden: Bool) {
        refreshButton.isHidden = refreshIsHidden
    }
    
    func update(title: String) {
        titleLabel.text = title
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
        view = loadNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
