//
//  DateSelectorView.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol DateSelectorViewDelegate: class {
    func dateSelectorRequestedForPreviousDate()
    func dateSelectorRequestedForNextDate()
}

@IBDesignable class DateSelectorView: AttributedView {
    @IBOutlet private var previousDateButton: UIButton!
    @IBOutlet private var nextDateButton: UIButton!
    @IBOutlet private var currentDateButton: UIButton!
    
    weak var delegate: DateSelectorViewDelegate?
 
    // MARK: - Actions
    @IBAction private func previousDateButtonTapped(_ sender: UIButton) {
        self.delegate?.dateSelectorRequestedForPreviousDate()
    }
    
    @IBAction private func nextDateButtonTapped(_ sender: UIButton) {
        self.delegate?.dateSelectorRequestedForNextDate()
    }
    
    // MARK: - Internal
    func update(currentDateString: String, previousDateString: String, nextDateString: String) {
        self.currentDateButton.setTitle(currentDateString, for: .normal)
        self.previousDateButton.setTitle(previousDateString, for: .normal)
        self.nextDateButton.setTitle(nextDateString, for: .normal)
    }
}
