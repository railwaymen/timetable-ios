//
//  MonthYearPickerView.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

class MonthYearPickerView: UIPickerView {
    private let months: [String] = {
        let dateFormatter = DateFormatter()
        let monthsRange = 0...11
        let months: [String] = monthsRange.map { dateFormatter.standaloneMonthSymbols[$0].localizedCapitalized }
        return months
    }()
    
    private let years: [Int] = {
        let calendar = Calendar(identifier: .gregorian)
        guard let nextYearDate = calendar.date(byAdding: .year, value: 1, to: Date()) else { return [] }
        let nextYear = calendar.component(.year, from: nextYearDate)
        return Array(1970...nextYear)
    }()
    
    var month: Int {
        get {
            self.selectedRow(inComponent: 0)
        }
        set {
            self.selectRow(newValue - 1, inComponent: 0, animated: false)
        }
    }
    
    var year: Int {
        get {
            self.years[self.selectedRow(inComponent: 1)]
        }
        set {
            guard let yearIndex = self.years.firstIndex(of: newValue) else { return }
            self.selectRow(yearIndex, inComponent: 1, animated: false)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
}

// MARK: - UIPickerViewDataSource
extension MonthYearPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.months.count
        case 1:
            return self.years.count
        default:
            return 0
        }
    }
}

// MARK: - UIPickerViewDelegate
extension MonthYearPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return self.months[row]
        case 1:
            return "\(self.years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0) + 1
        let year = self.years[self.selectedRow(inComponent: 1)]
        self.onDateSelected?(month, year)
        
        self.month = month
        self.year = year
    }
    
}

// MARK: - Private
extension MonthYearPickerView {
    private func commonSetup() {
        self.delegate = self
        self.dataSource = self
    }
}
