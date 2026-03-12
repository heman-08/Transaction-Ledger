//
//  TransactionListViewController.swift
//  Transaction-Ledger
//
//  Created by ATEU on 3/12/26.
//

import UIKit

class TransactionListViewController: UIViewController {

    // MARK: - MVVM: The ViewModel Instance
    // The View holds a reference to the ViewModel so it can ask it for data
    private let viewModel = TransactionViewModel()
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        return table
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Ledger"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupUI()
        setupTableView()
        
        // MVVM: Set up the communication bridge BEFORE asking for data
        setupBindings()
        
        // Start the UI loader, then tell the ViewModel to fetch from the internet
        loadingIndicator.startAnimating()
        viewModel.fetchTransactions()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        // Tell the table view that THIS file will handle its data and interactions
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - MVVM: The Binding
    private func setupBindings() {
        // Listen for the ViewModel's megaphone shout
        // We use [weak self] to prevent memory leaks (Retain Cycles)
        viewModel.onDataUpdated = { [weak self] in
            
            // Turn off the spinner and reload the table to show the new data!
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
// We use extensions to keep our code incredibly clean and readable
extension TransactionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // MVVM: The View asks the ViewModel how many items it has
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        // MVVM: The View asks the ViewModel for the specific item at this row
        let transaction = viewModel.transactions[indexPath.row]
        
        // Modern iOS cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = transaction.title
        content.secondaryText = "Transaction ID: \(transaction.id)"
        
        // Let's add a fake "banking" icon just to make it look professional
        content.image = UIImage(systemName: "dollarsign.circle.fill")
        content.imageProperties.tintColor = .systemGreen
        
        cell.contentConfiguration = content
        return cell
    }
    
    // Un-highlight the cell when tapped (good UX practice)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
