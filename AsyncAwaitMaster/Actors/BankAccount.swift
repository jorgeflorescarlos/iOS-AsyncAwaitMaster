//
//  BankAccount.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

enum BankError: Error {
    case insufficientFunds(Double)
}

actor BankAccount {
    
    let accountNumber: Int
    var balance: Double
    var transactions: [String] = []
    
    init(accountNumber: Int, balance: Double) {
        self.accountNumber = accountNumber
        self.balance = balance
    }
    
    func getTransactions() -> [String] {
        return transactions
    }
    
    nonisolated func getCurrentAPR() -> Double {
        return 0.2
    }
    
    func deposit(_ amount: Double) {
        balance += amount
        transactions.append("+\(amount), balance: \(balance)")
    }
    
    func transfer(amount: Double, to other: BankAccount) async throws {
        if amount > balance {
            throw BankError.insufficientFunds(amount)
        }
        
        balance -= amount
        await other.deposit(amount)
        transactions.append("-\(amount), balance: \(balance)")
    }
}
