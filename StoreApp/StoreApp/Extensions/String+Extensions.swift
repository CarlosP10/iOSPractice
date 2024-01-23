//
//  String+Extensions.swift
//  StoreApp
//
//  Created by Carlos Paredes on 23/1/24.
//

import Foundation

extension String {
    var isNumeric: Bool {
        Double(self) != nil
    }
}
