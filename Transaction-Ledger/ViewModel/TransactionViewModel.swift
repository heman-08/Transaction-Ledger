//
//  TransactionViewModel.swift
//  Transaction-Ledger
//
//  Created by ATEU on 3/12/26.
//



import CoreData // We must import this to talk to our database

class TransactionViewModel {
    
    var transactions: [Transaction] = []
    var onDataUpdated: (() -> Void)?
    
    func fetchTransactions() {
        
        // 1. OFFLINE FIRST: Immediately load whatever we saved to the database last time
        // This prevents the user from staring at a blank screen
        loadFromCoreData()
        
        // 2. FETCH FRESH DATA: Now, go to the internet to see if there is anything new
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let validData = data, error == nil else {
                print("❌ Network error! Relying purely on cached database data.")
                return
            }
            
            do {
                let downloadedData = try JSONDecoder().decode([Transaction].self, from: validData)
                
                // 3. Update our array with the fresh internet data
                self?.transactions = downloadedData
                
                // 4. Switch back to the Main Thread to update the UI
                DispatchQueue.main.async {
                    self?.onDataUpdated?()
                }
                
                // 5. CACHE IT: Save this fresh data to the device so it's ready for next time!
                self?.saveToCoreData(newTransactions: downloadedData)
                
            } catch {
                print("❌ Failed to decode JSON: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - Core Data Operations
    
    private func loadFromCoreData() {
        let context = CoreDataManager.shared.context
        
        // Create a request asking for everything in the TransactionEntity table
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        do {
            let savedEntities = try context.fetch(request)
            
            // Map the Core Data "Entities" back into our simple Swift "Structs"
            self.transactions = savedEntities.map { entity in
                Transaction(
                    id: entity.id ?? "",
                    symbol: entity.symbol ?? "",
                    name: entity.name ?? "Unknown",
                    current_price: entity.current_price                )
            }
            
            // If we actually found old data, tell the UI to show it immediately!
            if !self.transactions.isEmpty {
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
                print("📂 Loaded \(self.transactions.count) items from offline cache!")
            }
            
        } catch {
            print("❌ Failed to load from Core Data: \(error)")
        }
    }
    
    private func saveToCoreData(newTransactions: [Transaction]) {
        let context = CoreDataManager.shared.context
        
        // 1. Wipe the old database clean so we don't accidentally duplicate everything
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            
            // 2. Loop through the fresh internet data and save each one as a new database row
            for transaction in newTransactions {
                let newEntity = TransactionEntity(context: context)
                newEntity.id = transaction.id
                newEntity.symbol = transaction.symbol
                newEntity.name = transaction.name
                newEntity.current_price = transaction.current_price
            }
            
            // 3. Save the scratchpad to the device memory
            CoreDataManager.shared.saveContext()
            print("💾 Successfully updated offline cache with fresh data!")
            
        } catch {
            print("❌ Failed to save to Core Data: \(error)")
        }
    }
}
