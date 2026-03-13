//
//  Transaction.swift
//  Transaction-Ledger
//
//  Created by ATEU on 3/12/26.
//

import Foundation

// We make it 'Codable' so Swift knows how to automatically map the internet JSON to these properties
struct Transaction: Codable {
    let id: String
    let symbol: String
    let name: String
    let current_price: Double
}
