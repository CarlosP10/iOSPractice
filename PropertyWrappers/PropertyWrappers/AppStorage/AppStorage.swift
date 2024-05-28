//
//  AppStorage.swift
//  PropertyWrappers
//
//  Created by Carlos Paredes on 28/5/24.
//

import SwiftUI

struct AppStorageView: View {
    
    @State private var name: String = ""
    @AppStorage("appStorageName") var appStorageName: String = ""
    
    var body: some View {
        Form {
            TextField("Username", text: $name)
            HStack {
                Spacer()
                Button("Guardar") {
                    appStorageName = name
                }
                .padding()
                Spacer()
            }
            HStack {
                Spacer()
                Button("Imprimir Valor") {
                    print(UserDefaults.standard.string(forKey: "appStorageName"))
                }
                .padding()
                Spacer()
            }
        }
        .onAppear {
            name = appStorageName
        }
    }
}

#Preview {
    AppStorageView()
}
