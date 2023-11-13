//
//  TransactionPersistent.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import Foundation
import CoreData

final class TransactionPersistent {
    
    // MARK: - Properties
    private static let context = AppDelegate.persistentContainer.viewContext
    
    // MARK: - Methods
    static func save(_ transaction: Transaction) {
        guard let description = NSEntityDescription.entity(forEntityName: "TransactionEntity", in: context) else { return }
        let entity = TransactionEntity(entity: description, insertInto: context)
        entity.sign = transaction.sign.rawValue
        entity.sum = transaction.sum
        entity.date = transaction.date
        entity.typePayment = transaction.typePayment.rawValue
        entity.categoryTransaction = transaction.categoryTransaction.rawValue
        
        do {
            try context.save()
            postNotification()
        } catch {
            debugPrint("Saving transactions error: \(error)")
        }
    }
    
    static func delete(_ transaction: Transaction) {
        guard let entity = getEntity(for: transaction) else { return }
        context.delete(entity)
        
        do {
            try context.save()
            postNotification()
        } catch {
            debugPrint("Deleting transactions error: \(error)")
        }
    }
    
    static func fetchAll() -> [Transaction] {
        let request = TransactionEntity.fetchRequest()
        
        do {
            let objects = try context.fetch(request)
            return convert(entities: objects)
        } catch {
            debugPrint("Fetch transactions error: \(error)")
            return []
        }
    }
    
    private static func convert(entities: [TransactionEntity]) -> [Transaction] {
        entities.map { Transaction(sign: TransactionType(rawValue: $0.sign ?? "") ?? .refill,
                                   sum: $0.sum ?? "",
                                   typePayment: PaymentType(rawValue: $0.typePayment ?? "") ?? .card,
                                   categoryTransaction: CategoryTransaction(rawValue: $0.categoryTransaction ?? "") ?? .defaultCategory,
                                   date: $0.date ?? Date()) }
    }
    
    private static func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
    }
    
    private static func getEntity(for transaction: Transaction) ->  TransactionEntity? {
        let request = TransactionEntity.fetchRequest()
        let predicate = NSPredicate(format: "date = %@", transaction.date as NSDate)
        request.predicate = predicate
        
        do {
            let objects = try context.fetch(request)
            return objects.first
        } catch {
            debugPrint("Fetch transactions error: \(error)")
            return nil
        }
    }
}
