//
//  StoreHTTTPClient.swift
//  StoreApp
//
//  Created by Carlos Paredes on 18/1/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL, invalidServerRepsonse, decodingError
}

class StoreHTTTPClient {
    
    
    
    func getAllCategories() async throws -> [Category] {
        
        let (data, response) = try await URLSession.shared.data(from: URL.allCategories)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkError.invalidServerRepsonse
        }
        
        guard let categories = try? JSONDecoder().decode([Category].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return categories
    }
}
