//
//  EnvironmentObject.swift
//  PropertyWrappers
//
//  Created by Carlos Paredes on 24/5/24.
//

import SwiftUI

final class ViewModel: ObservableObject {
    @Published var counter: Int = 0
}

struct View1: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Counter \(viewModel.counter)")
                .bold()
                .font(.largeTitle)
            Text("View 1")
                .padding()
            View2()
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    View1()
}
