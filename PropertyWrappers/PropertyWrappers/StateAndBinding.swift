//
//  StateAndBinding.swift
//  PropertyWrappers
//
//  Created by Carlos Paredes on 24/5/24.
//

import SwiftUI

struct StateAndBinding: View {
    @State var counter: Int = 0
    var body: some View {
        ///$ es para pasarle el valor que va a leer
        CounterView(counter: $counter)
    }
}

struct CounterView: View {
    @Binding var counter: Int
    var body: some View {
        VStack(spacing: 20) {
            Text("\(counter)")
                .font(.largeTitle)
            Button("Incrementar") {
                counter += 1
            }
        }
    }
}


#Preview {
    StateAndBinding()
}
