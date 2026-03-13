//
//  TransactionListViewController.swift
//  Transaction-Ledger
//
//  Created by ATEU on 3/12/26.
//

import UIKit

class TransactionListViewController: UIViewController {

    private let viewModel = TransactionViewModel()
    
    // 1. Create the native Refresh Control
    private let refreshControl = UIRefreshControl()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Live Market" // Updated title to match our crypto data!
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupUI()
        setupTableView()
        setupBindings()
        
        loadingIndicator.startAnimating()
        viewModel.fetchTransactions()
    }
    
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
        tableView.dataSource = self
        tableView.delegate = self
        
        // 2. Attach the refresh control to our Table View
        // We tell it to run the 'handleRefresh' function whenever its value changes (when pulled)
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // 3. The function that triggers when the user pulls down
    // The @objc tag is required because UIRefreshControl uses Apple's older Objective-C target-action system
    @objc private func handleRefresh() {
        print("🔄 User pulled to refresh! Fetching latest prices from the internet...")
        
        // We just ask the ViewModel to do its job again!
        viewModel.fetchTransactions()
    }
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            self?.loadingIndicator.stopAnimating()
            
            // 4. Tell the refresh control to stop spinning and hide itself once the data arrives
            self?.refreshControl.endRefreshing()
            
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension TransactionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let transaction = viewModel.transactions[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(transaction.name) (\(transaction.symbol.uppercased()))"
        content.secondaryText = "Current Price: $\(transaction.current_price)"
        content.image = UIImage(systemName: "chart.line.uptrend.xyaxis.circle.fill")
        content.imageProperties.tintColor = .systemGreen
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
