//: [Previous](@previous)

import Foundation
import Combine

//Map permite transforma de un valor a otro
let intPublisher = PassthroughSubject<Int, Never>()

intPublisher
    .map{ String($0)}
    .sink { value in
    print("Value: \(value)")
}

intPublisher.send(35)
intPublisher.send(32)
//: [Next](@next)
