//: [Previous](@previous)

import Foundation
import Combine

struct User {
    let email:String
    let name:String
}

//Just permite que se publiquen valores y no permite que se publiquen errores
let user:User = .init(email: "hi@hi.com",
                      name: "Example")

let justPublisher = Just(user)

//justPublisher.sink { completion in
//    switch completion {
//    case .failure(let error):
//        print("Error: \(error)")
//    case .finished:
//        print("Finished")
//    }
//} receiveValue: { user in
//    print("User: \(user)")
//}

enum RegisterFormError: String, Error {
    case userExists = "User already exists"
    case wrongEmail = "Wrong Email"
    case wrongPassword = "Wrong Password"
    case unknown = "unknown"
}

let failPublisher = Fail<Any, RegisterFormError>(error: RegisterFormError.unknown)

//failPublisher.sink { completion in
//    switch completion {
//    case .failure(let error):
//        print("Error: \(error)")
//    case .finished:
//        print("Finished")
//    }
//} receiveValue: { user in
//    print("User: \(user)")
//}

///AnyPublisher: ayuda a pasar cualquier parametro
func register(user: User) -> AnyPublisher<User, RegisterFormError> {
    if user.email == "hola@hola.com" {
        return Just(user)
            .setFailureType(to: RegisterFormError.self)
            .eraseToAnyPublisher()//transformar just a anypublisher
    } else {
        return Fail(error: RegisterFormError.wrongEmail)
            .eraseToAnyPublisher()
    }
}

let cancellable = register(user: user)
    .sink { completion in
        switch completion {
        case .failure(let error):
            print("Error: \(error.rawValue)")
        case .finished:
            print("Finished")
        }
    } receiveValue: { user in
        print("User: \(user)")
    }


