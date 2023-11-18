//
//  TransactionEntity+CoreDataProperties.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//
//

import Foundation
import CoreData

extension TransactionEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var sign: String?
    @NSManaged public var sum: String?
    @NSManaged public var typePayment: String?
    @NSManaged public var categoryTransaction: String?
    
}

extension TransactionEntity : Identifiable {
    
}
