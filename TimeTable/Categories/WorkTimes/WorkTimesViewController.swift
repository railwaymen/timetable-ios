//
//  WorkTimesViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimesViewControlleralbe = (UIViewController & WorkTimesViewControllerType & WorkTimesViewModelOutput)

protocol WorkTimesViewControllerType: class {
    func configure(viewModel: WorkTimesViewModelType)
}

class WorkTimesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    private let tableViewEstimatedRowHeight: CGFloat = 90
    private let heightForHeader: CGFloat = 50
    private let workTimeTableViewCellReuseIdentifier = "WorkTimeTableViewCellReuseIdentifier"
    private let workTimesTableViewHeaderIdentifier = "WorkTimesTableViewHeaderIdentifier"
    private var viewModel: WorkTimesViewModelType!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    // MARK: - Action
    @IBAction func previousMonthButtonTapped(_ sender: UIButton) {
        viewModel.viewRequestedForPreviousMonth()
    }
    
    @IBAction func nextMonthButtonTapped(_ sender: Any) {
        viewModel.viewRequestedForNextMonth()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workTimeTableViewCellReuseIdentifier, for: indexPath)
        guard let workTimeCell = cell as? WorkTimeTableViewCell else { return UITableViewCell() }
        guard let cellViewModel = viewModel.viewRequestedForCellModel(at: indexPath, cell: workTimeCell) else { return UITableViewCell() }
        workTimeCell.configure(viewModel: cellViewModel)
        return workTimeCell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: workTimesTableViewHeaderIdentifier) as? WorkTimesTableViewHeaderable else {
            return nil
        }
        guard let headerViewModel = viewModel.viewRequestedForHeaderModel(at: section, header: header) else { return nil }
        header.configure(viewModel: headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }
}

extension WorkTimesViewController: WorkTimesViewModelOutput {
    
    func setUpView(with dateString: String) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableViewEstimatedRowHeight
        
        let nib = UINib(nibName: WorkTimesTableViewHeader.className, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: workTimesTableViewHeaderIdentifier)
        
        dateLabel.text = dateString
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func updateDateLabel(text: String) {
        dateLabel.text = text
    }
}

extension WorkTimesViewController: WorkTimesViewControllerType {
    func configure(viewModel: WorkTimesViewModelType) {
        self.viewModel = viewModel
    }
}
