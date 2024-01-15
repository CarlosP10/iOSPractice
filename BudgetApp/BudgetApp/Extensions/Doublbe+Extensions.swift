//
//  Doublbe+Extensions.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 15/1/24.
//

import Foundation

extension Double {
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
