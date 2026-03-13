//
//  TransactionLedgerTests.swift
//  TransactionLedgerTests
//
//  Created by ATEU on 3/12/26.
//

import XCTest
// This special import allows the test folder to read your main app's code!
@testable import Transaction_Ledger

final class TransactionViewModelTests: XCTestCase {

    // The object we are going to test (The "System Under Test" or SUT)
    var viewModel: TransactionViewModel!

    // setUp() runs automatically BEFORE every single test.
    // We use it to create a fresh, clean ViewModel so tests don't corrupt each other.
    override func setUp() {
        super.setUp()
        viewModel = TransactionViewModel()
    }

    // tearDown() runs automatically AFTER every single test.
    // We use it to destroy the ViewModel to free up memory.
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - The Actual Tests
    // Test functions MUST begin with the word "test" for Xcode to recognize them.
    
//    func test_InitialState_TransactionsArrayIsEmpty() {
//        // 1. ARRANGE (Set up the environment)
//        // In this case, our setUp() function already arranged our fresh ViewModel.
//        
//        // 2. ACT (Execute the behavior you want to test)
//        let count = viewModel.transactions.count
//        
//        // 3. ASSERT (Verify the result is exactly what you expect)
//        XCTAssertEqual(count, 0, "The ViewModel must start with an empty array to prevent crashing the Table View before data loads.")
//    }
    func test_TransactionArray_StoresMockDataCorrectly() {
            // 1. ARRANGE: Create "Fake" data that mimics our live CoinGecko API
            let mockCrypto1 = Transaction(id: "bitcoin", symbol: "btc", name: "Bitcoin", current_price: 65000.0)
            let mockCrypto2 = Transaction(id: "ethereum", symbol: "eth", name: "Ethereum", current_price: 3500.0)
            
            // 2. ACT: Inject this fake data directly into the ViewModel
            viewModel.transactions = [mockCrypto1, mockCrypto2]
            
            // 3. ASSERT: Prove the ViewModel behaves exactly as expected
            // Check the total count
            XCTAssertEqual(viewModel.transactions.count, 2, "The ViewModel should contain exactly 2 items.")
            
            // Check specific properties to ensure data wasn't corrupted
            XCTAssertEqual(viewModel.transactions.first?.name, "Bitcoin", "The first item's name must be Bitcoin.")
            XCTAssertEqual(viewModel.transactions.last?.current_price, 3500.0, "The last item's price must be exactly 3500.0.")
        }
}
