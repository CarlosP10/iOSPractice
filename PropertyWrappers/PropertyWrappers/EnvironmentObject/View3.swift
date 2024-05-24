//
//  View3.swift
//  PropertyWrappers
//
//  Created by Carlos Paredes on 24/5/24.
//

import SwiftUI

struct View3: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("View 3")
                .padding()
            Button("Incrementar") {
                viewModel.counter += 1
            }
        }
    }
}

#Preview {
    View3(viewModel: ViewModel())
}
