//
//  String+Extensions.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 11/1/24.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    func isGreatorThan(_ value: Double) -> Bool {
        guard self.isNumeric else {
            return false
        }
        
        return Double(self)! > value
    }
}
