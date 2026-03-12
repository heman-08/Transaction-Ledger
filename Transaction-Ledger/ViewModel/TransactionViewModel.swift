//
//  TransactionViewModel.swift
//  Transaction-Ledger
//
//  Created by ATEU on 3/12/26.
//

import Foundation

// We make it 'Codable' so Swift knows how to automatically map the internet JSON to these properties
struct Transaction: Codable {
    let id: Int
    let title: String
    let body: String
}

import Foundation

class TransactionViewModel {
    
    // This array will hold the data once it downloads
    var transactions: [Transaction] = []
    
    // The "megaphone" to tell the View Controller the data is ready
    var onDataUpdated: (() -> Void)?
    
    func fetchTransactions() {
        // We are using a free fake API that returns 100 posts (we'll treat them as transactions)
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        // Start the background network task
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            // 1. Ensure we got valid data back
            guard let validData = data, error == nil else {
                print("❌ Network error!")
                return
            }
            
            // 2. Decode the JSON into our Swift array
            do {
                let downloadedData = try JSONDecoder().decode([Transaction].self, from: validData)
                
                self?.transactions = downloadedData
                
                // 3. THE GOLDEN RULE: Switch back to the Main Thread to update the UI
                DispatchQueue.main.async {
                    self?.onDataUpdated?()
                }
                
            } catch {
                print("❌ Failed to decode JSON: \(error)")
            }
        }
        
        task.resume() // Don't forget to start the task!
    }
}
