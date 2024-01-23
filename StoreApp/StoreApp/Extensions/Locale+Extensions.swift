//
//  Locale+Extensions.swift
//  StoreApp
//
//  Created by Carlos Paredes on 19/1/24.
//

import Foundation

extension Locale {
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
}
