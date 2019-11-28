//
//  ProjectPickerViewController.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias ProjectPickerViewControllerable = ProjectPickerViewControllerType & ProjectPickerViewModelOutput

protocol ProjectPickerViewControllerType: class {
    func configure(viewModel: ProjectPickerViewModelType)
}

class ProjectPickerViewController: UIViewController {
    private var tableView: UITableView!
    private var searchController: UISearchController!
    
    private var viewModel: ProjectPickerViewModelType!
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.viewModel.loadView()
    }

    // MARK: - Actions
    @objc private func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }
}

// MARK: - UITableViewDataSource
extension ProjectPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: ProjectPickerCell.reuseIdentifier),
            let cell = dequeuedCell as? ProjectPickerCellable else { return UITableViewCell() }
        self.viewModel.configure(cell: cell, for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProjectPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.cellDidSelect(at: indexPath)
    }
}

// MARK: - UISearchResultsUpdating
extension ProjectPickerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchResults(for: searchController.searchBar.text ?? "")
    }
}

// MARK: - ProjectPickerViewModelOutput
extension ProjectPickerViewController: ProjectPickerViewModelOutput {
    func setUp() {
        self.setUpTableView()
        self.setUpSearchController()
        self.setUpBarItems()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func setBottomContentInsets(_ inset: CGFloat) {
        let calculatedInset = max(inset - self.tableView.safeAreaInsets.bottom, 0)
        self.tableView.contentInset.bottom = calculatedInset
        self.tableView.scrollIndicatorInsets.bottom = calculatedInset
    }
}

// MARK: - ProjectPickerViewControllerType
extension ProjectPickerViewController: ProjectPickerViewControllerType {
    func configure(viewModel: ProjectPickerViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension ProjectPickerViewController {
    private func setUpTableView() {
        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(
            UINib(nibName: String(describing: ProjectPickerCell.self), bundle: nil),
            forCellReuseIdentifier: ProjectPickerCell.reuseIdentifier)
        self.tableView.keyboardDismissMode = .interactive
    }
    
    private func setUpSearchController() {
        self.searchController = UISearchController()
        self.navigationItem.searchController = self.searchController
        self.searchController.searchBar.tintColor = .crimson
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setUpBarItems() {
        let systemItem: UIBarButtonItem.SystemItem
        if #available(iOS 13, *) {
            systemItem = .close
        } else {
            systemItem = .cancel
        }
        let closeButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(self.closeButtonTapped))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
        self.navigationController?.navigationBar.tintColor = .crimson
    }
}
