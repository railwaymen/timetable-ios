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
    
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        setUpViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        viewModel.closeButtonTapped()
    }
    
    // MARK: - Private
    private func setUpViews() {
        setUpTableView()
        setUpSearchController()
    }
    
    private func setUpTableView() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: ProjectPickerCell.self), bundle: nil),
                           forCellReuseIdentifier: ProjectPickerCell.reuseIdentifier)
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setUpSearchController() {
        searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = .crimson
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
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
        viewModel.configure(cell: cell, for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProjectPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellDidSelect(at: indexPath)
    }
}

// MARK: - UISearchControllerDelegate
extension ProjectPickerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(for: searchController.searchBar.text ?? "")
    }
}

// MARK: - ProjectPickerViewModelOutput
extension ProjectPickerViewController: ProjectPickerViewModelOutput {
    func setUp() {
        let systemItem: UIBarButtonItem.SystemItem
        if #available(iOS 13, *) {
            systemItem = .close
        } else {
            systemItem = .cancel
        }
        let closeButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(closeButtonTapped))
        navigationItem.setRightBarButton(closeButton, animated: false)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func setBottomContentInsets(_ inset: CGFloat) {
        let calculatedInset = max(inset - tableView.safeAreaInsets.bottom, 0)
        tableView.contentInset.bottom = calculatedInset
        tableView.scrollIndicatorInsets.bottom = calculatedInset
    }
}

// MARK: - ProjectPickerViewControllerType
extension ProjectPickerViewController: ProjectPickerViewControllerType {
    func configure(viewModel: ProjectPickerViewModelType) {
        self.viewModel = viewModel
    }
}
