//
//  ContentView.swift
//  PropertyWrappers
//
//  Created by Carlos Paredes on 24/5/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var counter: Int = 0
    
    var body: some View {
        VStack {
            Text("Contador \(counter)")
                .bold()
                .font(.largeTitle)
                .padding()
            Button("Incrementar Contador") {
                counter += 1
            }
            ListVideos()
            Spacer()
        }
    }
}


struct ListVideos: View {
    ///Debemos iniciar con @ObservedObject si queremos mostrar los cambios
    ///@ObservedObject se vuelve a iniciar cada vez que la pantalla se redibuja
    //@ObservedObject private var videoViewModel = VideoViewModel()
    ///Con @StateObject el estado no se pierde
    @StateObject private var videoViewModel = VideoViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ///El mejor uso con State y Observed es que si es la primera vez que se muestra es mejor solo llamar State y si se usa en otra vista solo Observed 
                RemoveVideos(videoViewModel: videoViewModel)
            }
            List(videoViewModel.videosModel, id: \.self) { video in
                Text(video)
            }
            .navigationTitle("Videos")
            .navigationBarItems(leading:
                                    Button("Añadir", action: videoViewModel.addMoreTopics)
            )
        }
    }
}

struct RemoveVideos: View {
    
    @ObservedObject var videoViewModel: VideoViewModel
    
    var body: some View {
        Text("SwiftBeta Remove Video")
    }
}

#Preview {
    ContentView()
}

final class VideoViewModel: ObservableObject {
    ///@Published similar a @State en lugar de usarse en un abstract se usa en una clase
    @Published var videosModel: [String] = []
    
    init(){
        videosModel = ["Aprende SwiftUI",
                       "Aprende Xcode",
                       "Aprende Swift" ]
    }
    
    func addMoreTopics() {
        videosModel.append("Aprende CI/CD")
        videosModel.append("Aprende Git")
    }
}
