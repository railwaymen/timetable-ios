//
//  DatePickerTextField.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 20/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

class DatePickerTextField: UITextField {

    // MARK: - Overridden
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tintColor = .clear
        self.clearButtonMode = .never
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
