//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 17/1/24.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    var transactionTotal: Double {
        
        let transactionsArray: [Transaction] = transaction?.toArray() ?? []
        return transactionsArray.reduce(0) { next, transaction in
            next + transaction.amount
        }
    }
    
    var remainingAmount: Double {
        amount - transactionTotal
    }
    
}
