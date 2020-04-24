//
//  YearPickerView.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

class YearPickerView: UIPickerView {
    private let offset = 10
    private let range = 0...20
    private var years: [Int] = []
    
    private var currentYear = Calendar.autoupdatingCurrent.component(.year, from: Date())
    
    var selectedYear: Int = 0 {
        didSet {
            self.selectRow(forYear: self.selectedYear)
        }
    }
    
    var yearSelected: ((_ year: Int) -> Void)?
    
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
extension YearPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.years.count
    }
}

// MARK: - UIPickerViewDelegate
extension YearPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let index = self.selectedRow(inComponent: 0)
        guard let year = self.years[safeIndex: index] else { return }
        self.currentYear = year
        self.selectedYear = year
        self.yearSelected?(year)
    }
}

// MARK: - Private
extension YearPickerView {
    private func commonSetup() {
        let startYear = self.currentYear - self.offset
        self.years = self.range.map { startYear + $0 }
        
        self.delegate = self
        self.dataSource = self
        
        self.selectRow(forYear: self.selectedYear)
    }
    
    private func selectRow(forYear year: Int) {
        guard let index = self.years.firstIndex(of: year) else { return }
        self.selectRow(index, inComponent: 0, animated: false)
    }
}
