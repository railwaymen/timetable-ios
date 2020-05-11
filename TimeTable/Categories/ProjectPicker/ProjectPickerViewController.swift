//
//  ProjectPickerViewController.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias ProjectPickerViewControllerable = UIViewController & ProjectPickerViewControllerType & ProjectPickerViewModelOutput

protocol ProjectPickerViewControllerType: class {
    func configure(viewModel: ProjectPickerViewModelType)
}

class ProjectPickerViewController: UIViewController {
    private var tableView: UITableView!
    private var searchController: UISearchController!
    
    private var viewModel: ProjectPickerViewModelType!
    
    // MARK: - Overridden
    override func loadView() {
        super.loadView()
        self.viewModel.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.viewDidDisappear()
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
        guard let cell = tableView.dequeueReusableCell(ProjectPickerCell.self, for: indexPath) else { return UITableViewCell() }
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
    
    func setBottomContentInset(_ inset: CGFloat) {
        let calculatedInset = max(inset - self.tableView.safeAreaInsets.bottom, 0)
        self.tableView.contentInset.bottom = calculatedInset
        self.tableView.verticalScrollIndicatorInsets.bottom = calculatedInset
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
        self.tableView.register(ProjectPickerCell.self)
        self.tableView.keyboardDismissMode = .interactive
    }
    
    private func setUpSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.tintColor = .tint
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController?.showsSearchResultsController = false
        self.definesPresentationContext = true
        self.navigationItem.searchController = self.searchController
    }
    
    private func setUpBarItems() {
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .closeButton,
            target: self,
            action: #selector(self.closeButtonTapped))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
        self.navigationController?.navigationBar.tintColor = .tint
    }
}
