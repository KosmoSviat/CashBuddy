//
//  TransactionsList.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import Foundation
import UIKit

class AddTransactionView: UIView {
    let store: AppStore

    init(store: AppStore) {
        self.store = store
    }

    private var summ: Int = 0
    private var selectedPaymentMethod: PaymentMethod = ...
    private var selectedCategory: Category = ...

    let textField: UITextField

    func updateUI() {
        
    }

    @objc
    func didPressDebit() {
        store.state.addDebitTransaction()
        store.save {}
        textField.resignFirstResponder()
        textField.text = ""
        selectedCategory = .default
        updateUI()
    }
}

struct AppState {
    var transactions: [Transaction] = []

    var transactionBlueprint: Transaction.Blueprint

//    var selectedTab: Tab
}

class AppPersistenceService {
    func getTransactions(completion: ([Transaction]) -> Void) {

    }

    func setTransactions(transactions: [Transaction], completion: () -> Void) {

    }
}

final class AppStore {
    @Published var state: AppState = .init()

    let persistenceService: AppPersistenceService

    init(state: AppState, persistenceService: AppPersistenceService) {
        self.state = state
        self.persistenceService = persistenceService
    }

    func save(completion: () -> Void) {
//        persistenceService.setTransactions(state.transactions) { [self] in
//            completion()
//        }
    }

    func load(completion: () -> Void) {
//        persistenceService.getTransactions { [self] transactions in
//            state.transactions = transactions
//            completion()
//        }
    }
}

extension AppState {
    func addTransaction(summ: Int, paymentMethod: ..., category: ...) {
        let transaction = Transaction(
            sign: ...,
            sum: ...,
            typePayment: ...,
            categoryTransaction: ...,
            date: ...
        )
        transactions.append(transaction)
    }

    var sortedTransactions: [Transaction] {
        fatalError()
    }

    var transactionsByDate: [Date: [Transaction]] {
        fatalError()
    }

    var sectionDates: [Date] {
        fatalError()
    }

    var balanceTotal: Int {
        fatalError()
    }

    var refillTotal: Int {
        fatalError()
    }

    var debitTotal: Int {
        fatalError()
    }
}

final class TransactionsList2 {
    static var shared = TransactionsList2(remoteService: RemoteTransactionService(), persistentService: CoreDataTransactionService())

    private let remoteService: TransactionService
    private let persistentService: TransactionService

    init(remoteService: TransactionService, persistentService: TransactionService) {
        self.remoteService = remoteService
        self.persistentService = persistentService
    }
}

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
