//
//  CreateProductRequest.swift
//  StoreApp
//
//  Created by Carlos Paredes on 23/1/24.
//

import Foundation

struct CreateProductRequest: Encodable {
    
    let title: String
    let price: Double
    let description: String
    let categoryId: Int
    let images: [String]
    
    init(product: Product) {
        title = product.title
        price = product.price
        description = product.description
        categoryId = product.category.id
        images = product.images ?? []
    }
    
}
