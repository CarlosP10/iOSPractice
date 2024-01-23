//
//  CategoryPickerView.swift
//  StoreApp
//
//  Created by Carlos Paredes on 22/1/24.
//

import SwiftUI

struct CategoryPickerView: View {
    
    let client = StoreHTTTPClient()
    @State private var categories: [Category] = []
    @State private var selectedCategory: Category?
    
    let onSelected: (Category) -> Void
    
    var body: some View {
        Picker("Categories", selection: $selectedCategory) {
            ForEach(categories, id: \.id) { category in
                //Tag need to be optional to listen onChange
                Text(category.name).tag(Optional(category))
            }
        }
        .onChange(of: selectedCategory, perform: { category in
            if let category {
                onSelected(category)
            }
        })
        .pickerStyle(.wheel)
            .task {
                do {
                    categories = try await client.getAllCategories()
                    selectedCategory = categories.first
                } catch {
                    print(error)
                }
            }
    }
}

#Preview {
    CategoryPickerView(onSelected: { _ in})
}
