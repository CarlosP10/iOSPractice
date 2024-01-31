//
//  DeleteProductResponse.swift
//  StoreApp
//
//  Created by Carlos Paredes on 31/1/24.
//

import Foundation

struct DeleteProductResponse: Decodable {
    var rta: Bool?
    var statusCode: Int?
    var message: String?
    var error: String?
}
