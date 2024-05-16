//: [Previous](@previous)
    
import Foundation

//MARK: - PassthroughSubject
struct Weather {
    
    /// Int para enviar lo valores enteros,
    /// Error: porque tambien podemos enviar errores
    let weatherPublisher = PassthroughSubject<Int, Error>()
    
    func getWeatherInfo() {
        weatherPublisher.send(35)
        ///Si se manda este finished no se va a publicar ningun valor despues de este
        //weatherPublisher.send(completion: .finished)
        ///en este caso lo que va a pasar es que se van a detener los demas parametros tambien
        weatherPublisher.send(completion: .failure(URLError(.badURL)))
        weatherPublisher.send(32)
    }
}
 
let weather = Weather()
weather.weatherPublisher.sink { completion in
    switch completion {
        //de esta manera si falla o termina podemos asignar diferentes funcionalidades
    case .failure(let error):
        print("Error\(error.localizedDescription)")
    case .isFinished:
        print("Finished")
    }
} receiveValue: { value in
    print("Values: \(value)")
}
weather.getWeatherInfo()

//MARK: - CurrentValueSubject
struct BotApp {
    var onboardingPublisher = CurrentValueSubject<String, Error>("Bienvenido a Swifbeta!")
    
    func startOnboarding() {
        onboardingPublisher.send("Crea una conversacion con algun contacto")
    }
}

let appBot = BotApp()
appBot.onboardingPublisher.handleEvents(receiveSubscription: { subscription in
    print("1. subscription receiver: \(subscription)")
}, receiveOutput: { value in
    print("2. value received: \(value)")
}, receiveCompletion: { completion in
    print("3. completion received \(completion)")
}, receiveCancel: {
    print("4. cancel received")
}, receiveRequest: { request in
    print("5. request received ")
}).sink { completion in
    switch completion {
    case .failure(let error):
        print("Error\(error.localizedDescription)")
    case .isFinished:
        print("Finished")
    }
} receiveValue: { value in
    print("Values: \(value)")
}

appBot.startOnboarding()

