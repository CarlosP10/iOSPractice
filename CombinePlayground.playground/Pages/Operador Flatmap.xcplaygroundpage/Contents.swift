//: [Previous](@previous)

import Foundation
import Combine

struct User {
    let email:String
    let name:String
}

let user:User = .init(email: "hi@hi.com",
                      name: "Example")


enum RegisterFormError: String, Error {
    case userExists = "User already exists"
    case wrongEmail = "Wrong Email"
    case wrongPassword = "Wrong Password"
    case unknown = "unknown"
}

func register(user: User) -> AnyPublisher<User, RegisterFormError> {
    if user.email == "hi@hi.com" {
        return Just(user)
            .setFailureType(to: RegisterFormError.self)
            .eraseToAnyPublisher()//transformar just a anypublisher
    } else {
        return Fail(error: RegisterFormError.wrongEmail)
            .eraseToAnyPublisher()
    }
}

func save(user: User) -> AnyPublisher<Bool, RegisterFormError> {
    if user.name == "Exampled" {
        return Just(true)
            .setFailureType(to: RegisterFormError.self)
            .eraseToAnyPublisher()//transformar just a anypublisher
    } else {
        return Fail(error: RegisterFormError.userExists)
            .eraseToAnyPublisher()
    }
}

//Flatmap funciona para concatenar servicios
register(user: user)
    .flatMap { user in
        save(user: user)
    }
    .catch({ _ in
        Just(false)
    })
    .sink { completion in
        switch completion {
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        case .finished:
            print("Finished")
        }
    } receiveValue: { value in
        print("Usuario registrado y almacenado en la base de datos. REGISTERED -> \(value)")
    }

