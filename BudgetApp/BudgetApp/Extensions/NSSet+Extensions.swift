//
//  NSSet+Extensions.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 17/1/24.
//

import Foundation

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map { $0 as! T }
        return array
    }
}
