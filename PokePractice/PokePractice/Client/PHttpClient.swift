//
//  PHttpClient.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.

import Foundation
import Combine

///Handle error with enum case
enum NetworkError: Error {
    case invalidURL, invalidServerResponse, decodingError, invalidData
}

///Handle http method and pass parameters
enum HttpMethod {
    case get([URLQueryItem])
    case post(Data?)
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

/// blueprint for making HTTP requests and decoding
struct Resource<T: Codable> {
    let url: URL
    var headers: [String: String] = [:]
    var method: HttpMethod = .get([])
}

class PHttpClient {
    private var cancellableSet: Set<AnyCancellable> = []
    /// executing HTTP requests, decoding their responses, and returning the decoded data
    /// - Parameter resource:  contains the details of the request
    /// - Returns: decoded T object,, representing the data retrieved from the server.
    func load<T: Codable>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: resource.url)
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
            }
            request = URLRequest(url: url)
        case .post(let data):
            request.httpBody = data
        }
        
        request.allHTTPHeaderFields = resource.headers
        request.httpMethod = resource.method.name
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "accept": "application/json"
        ]
        
        let session = URLSession(configuration: configuration)
        //print("Starting network request to: \(request.url?.absoluteString ?? "No URL")")
        let dataTaskPublisher = session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { result -> T in
                
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    print("Invalid server response")
                    throw NetworkError.invalidServerResponse
                }
                // Debugging HTTP response status code
                //print("HTTP Response Status Code: \(httpResponse.statusCode)")
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    print("Server responded with an error: \(httpResponse.statusCode)")
                    throw NetworkError.invalidServerResponse
                }
                
                // Debugging received data
                if let dataString = String(data: result.data, encoding: .utf8) {
                    //print("Received Data: \(dataString)")
                }
                
                //return data
                
                do {
                    return try JSONDecoder().decode(T.self, from: result.data)
                } catch {
                    print("Decoding error: \(error)")
                    throw NetworkError.decodingError
                }
            }
//            .decode(type: T.self, decoder: JSONDecoder())
//            .receive(on: RunLoop.main)
            .mapError { error -> Error in
                if let urlError = error as? URLError {
                    print("URL error: \(urlError)")
                    return NetworkError.invalidData
                } else {
                    print("Unknown error: \(error)")
                    return NetworkError.decodingError
                }
            }
            .eraseToAnyPublisher()
        
        return dataTaskPublisher
    }
    
}
