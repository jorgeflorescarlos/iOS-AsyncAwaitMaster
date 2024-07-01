//
//  BankAccountView.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI

struct BankAccountView: View {
    @State var bankAccount = BankAccount(accountNumber: 123, balance: 50000)
    @State var otherAccount = BankAccount(accountNumber: 456, balance: 100)
    
    @State var balance1 = 50000.0
    @State var balance2 = 100.0
    
    @State var bank1Transactions: [String] = []
    @State var bank2Transactions: [String] = []
    
    @State var errorMessage = ""
    @State var showError = false
    
    var body: some View {
        List {
            Section("Goal") {
                Text("Use actors to simplify concurrency in transactions between accounts.")
            }
            Section("Definition") {
                Text("In Swift, an actor is a reference type introduced in Swift 5.5 as part of its advanced concurrency model. Its primary role is to prevent data races and ensure safe access to shared mutable state in concurrent programming environments.")
            }
            Section("Example") {
                Text("Bank account balance 1: \(balance1)")
                Text("Bank account balance 2: \(balance2)")
                Button {
                    let _ = bankAccount.getCurrentAPR()
                    transfer()
                    Task {
                        bank1Transactions = await bankAccount.getTransactions()
                        bank2Transactions = await otherAccount.getTransactions()
                    }
                    
                } label: {
                    Text("Make 100 instant transactions of $300")
                }
                .alert("Error", isPresented: $showError) {
                    Button("OK") {}
                } message: {
                    Text(errorMessage)
                }
            }
            Section("Transactions") {
                HStack {
                    VStack {
                        Section("Account 1") {
                            ForEach(bank1Transactions, id: \.self) { transaction in
                                Text(transaction)
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Section("Account 2") {
                            ForEach(bank2Transactions, id: \.self) { transaction in
                                Text(transaction)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func transfer() {
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            Task {
                do {
                    try await bankAccount.transfer(amount: 300, to: otherAccount)
                    balance1 = await bankAccount.balance
                    balance2 = await otherAccount.balance
                } catch {
                    errorMessage = error.localizedDescription
                    showError.toggle()
                }
            }
        }
    }
}

#Preview {
    BankAccountView()
}
