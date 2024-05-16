//: [Previous](@previous)

import Foundation
import Combine

enum SwiftError: Error {
    case errorStringToInt
}

///Esta funcion es para retorna un int desde un string y si no un error
func mapStringToInt(with stringValue: String) throws -> Int {
    guard let result = Int(stringValue) else {
        throw SwiftError.errorStringToInt
    }
    return result
}

let stringPublisher = PassthroughSubject<String, SwiftError>()

stringPublisher
    .tryMap{ value in
        try mapStringToInt(with: value)
    }
    .sink { finished in
    print("finished; \(finished)")
} receiveValue: { value in
    print("value; \(value)")
}

stringPublisher.send("35")
stringPublisher.send("hola")
stringPublisher.send("32")
//: [Next](@next)
