//
//  Transaction.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import Foundation

struct Transaction {
    let sign: TransactionType
    let sum: String
    let typePayment: PaymentType
    let categoryTransaction: CategoryTransaction
    let date: Date

    struct BluePrint {
        var int: Int?
        var category: Category?
        var paymentMethod: PM?
    }

    enum Category: String {
        case food = "Food"
        case transport = "Transport"
        case medicine = "Medicine"
        case entertainment = "Entertainment"
        case cloth = "Cloth"
        case household = "Household"
        case rent = "Rent"
        case defaultCategory = "Not selected"
    }
}

enum TransactionType: String {
    case refill = "+"
    case debit = "-"
}

enum PaymentType: String {
    case card = "card"
    case cash = "cash"
}

enum CategoryTransaction: String {
    case food = "Food"
    case transport = "Transport"
    case medicine = "Medicine"
    case entertainment = "Entertainment"
    case cloth = "Cloth"
    case household = "Household"
    case rent = "Rent"
    case defaultCategory = "Not selected"
}
