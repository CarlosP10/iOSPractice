//
//  SceneStorageView.swift
//  PropertyWrappers
//
//  Created by Carlos Paredes on 31/5/24.
//

import SwiftUI

struct SceneStorageView: View {
    //Funciona siempre y cuando no se cierre la app, y siempre se mantenga en background
    @SceneStorage("tweet") private var tweet: String = ""
    @SceneStorage("toggle_publisher_bool") private var togglePublisherBestHour: Bool = false
    
    var body: some View {
        Form {
            TextEditor(text: $tweet)
                .frame(width: 300, height: 300)
            Toggle("Publicar a la mejor hora", isOn: $togglePublisherBestHour)
                .padding()
            HStack {
                Spacer()
                Button(togglePublisherBestHour ? "Publicar a la mejor hora" : "Publicar ahora") {
                    print("Publicando...")
                }
                Spacer()
            }
        }
    }
}

#Preview {
    SceneStorageView()
}
