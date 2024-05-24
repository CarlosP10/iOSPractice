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
    
    @State private var videosModel: [String] = []
    
    var body: some View {
        NavigationView {
            List(videosModel, id: \.self) { video in
                Text(video)
            }
            .navigationTitle("Videos")
            .navigationBarItems(leading:
                                    Button("Añadir", action: addMoreTopics)
            )
        }
        .onAppear {
            videosModel = [
                "Aprender X",
                "Aprender Y",
                "Aprender Z"
            ]
        }
    }
    
    func addMoreTopics(){
        videosModel.append("Aprende U")
        videosModel.append("Aprende O")
    }
}

#Preview {
    ContentView()
}

final class VideoViewModel {
    var videosModel: [String] = []
    
    init(){
        videosModel = ["Aprende SwiftUI",
                       "Aprende Xcode",
                       "Aprende Swift" ]
    }
    
    func addMoreTopics() {
        videosModel.append ( "Aprende CI/CD" )
        videosModel.append("Aprende Git" )
    }
}
