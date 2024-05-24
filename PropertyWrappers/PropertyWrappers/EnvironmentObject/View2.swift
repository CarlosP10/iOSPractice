//
//  View2.swift
//  PropertyWrappers
//
//  Created by Carlos Paredes on 24/5/24.
//

import SwiftUI

struct View2: View {
    
    var body: some View {
        VStack {
            Text("View 2")
                .padding()
            View3()
        }
    }
}

#Preview {
    View2()
}
