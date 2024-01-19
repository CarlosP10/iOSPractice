//
//  Product.swift
//  StoreApp
//
//  Created by Carlos Paredes on 19/1/24.
//

import Foundation

struct Product: Codable {
    var id: Int?
    let title: String
    let price: Double
    let description: String
    let image: [URL]?
    let category: Category
}
