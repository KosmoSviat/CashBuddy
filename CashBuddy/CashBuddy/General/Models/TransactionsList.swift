//
//  TransactionsList.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import Foundation

final class TransactionsList {
    
    // MARK: - Singletone
    static var shared = TransactionsList()
    private init() {
        getTransactions()
    }
    
    // MARK: - Properties
    var transactions: [Transaction] = [] {
        didSet {
            getTotalBalance()
        }
    }
    var transactionsByDate: [Date: [Transaction]] = [:]
    var sectionDates: [Date] = []
    var balanceTotal = 0
    var refillTotal = 0
    var debitTotal = 0
    
    // MARK: - Methods
    func getTransactions() {
        transactions = TransactionPersistent.fetchAll()
        transactions.sort{ $0.date > $1.date }
        transactionsByDate.removeAll()
        sectionDates.removeAll()
        
        transactions.forEach { transaction in
            let date = Calendar.current.startOfDay(for: transaction.date)
            
            if transactionsByDate[date] == nil {
                transactionsByDate[date] = [transaction]
                sectionDates.append(date)
            } else {
                transactionsByDate[date]?.append(transaction)
            }
        }
    }
    
    private func getTotalBalance() {
        refillTotal = transactions.filter{ $0.sign == .refill }.reduce(0, { $0 + (Int($1.sum) ?? 0) })
        debitTotal = transactions.filter{ $0.sign == .debit }.reduce(0, { $0 + (Int($1.sum) ?? 0) })
        balanceTotal = refillTotal - debitTotal
    }
    
    func getStatistics(category: CategoryTransaction) -> (Float, Int) {
        let selectedCategoryTransactions = transactions.filter{ $0.categoryTransaction == category }.filter { $0.sign == .debit }
        let sumSelectedCategoryTransactions = selectedCategoryTransactions.reduce(0, { $0 + (Int($1.sum) ?? 0) })
        return (Float(sumSelectedCategoryTransactions) / Float(debitTotal), sumSelectedCategoryTransactions)
    }
}
