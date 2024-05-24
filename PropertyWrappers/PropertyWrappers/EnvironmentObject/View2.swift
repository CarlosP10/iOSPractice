//
//  View2.swift
//  PropertyWrappers
//
//  Created by Carlos Paredes on 24/5/24.
//

import SwiftUI

struct View2: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("View 2")
                .padding()
            View3(viewModel: viewModel)
        }
    }
}

#Preview {
    View2(viewModel: ViewModel())
}
