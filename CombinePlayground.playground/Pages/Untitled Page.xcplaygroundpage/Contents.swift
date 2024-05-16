import UIKit
import Combine

var myArray = ["1", "2", "3", "4"]

//MARK: - PUBLISHER
//1 forma de crear un publisher
let myPublisher = myArray.publisher

//2 forma de crear un publisher, esta manera no publica errores
//let just = Just(["1", "2", "3", "4"])

///Otras formas  de crear publishers
//Current ValueSubject
//PassthroughSubject

//MARK: - SUSCRIBER
//1
///Este metodo se llama cuando ha acabado de enviarse todos los objetos

myPublisher.sink { isFinished in
    print("isFinished: \(isFinished)")
///Este metodo se llama cuando ha recibido un valor
} receiveValue: { value in
    print("value receiver: \(value)")
}

class YoutubeChannel {
    var numberOfSubscribers: Int = 0
}

let justInteger = Just(2020)
let swiftBetaChannle = YoutubeChannel()
justInteger.assign(to: \YoutubeChannel.numberOfSubscribers, on: swiftBetaChannle)
print(justInteger)
swiftBetaChannle.numberOfSubscribers
