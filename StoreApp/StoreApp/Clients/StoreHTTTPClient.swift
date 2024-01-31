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

enum HttpMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var headers: [String: String] = [:]
    var method: HttpMethod = .get([])
}

class StoreHTTTPClient {
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
         
        var request = URLRequest(url: resource.url)
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.invalidURL
            }
            
            request = URLRequest(url: url)
        case .post(let data):
            request.httpBody = data
        default:
            break
        }
        
        request.allHTTPHeaderFields = resource.headers
        request.httpMethod = resource.method.name
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type":"application/json"]
        
        let session = URLSession(configuration: configuration)
        
        let (data, response) = try await session.data(for: request)
        guard let _ = response as? HTTPURLResponse
        else {
            throw NetworkError.invalidServerRepsonse
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result
    }
    
}
