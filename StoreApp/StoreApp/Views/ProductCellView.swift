//
//  ProductCellView.swift
//  StoreApp
//
//  Created by Carlos Paredes on 19/1/24.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Text(product.title).bold()
                Text(product.description)
            }
            Spacer()
            Text(product.price, format: .currency(code: Locale.currencyCode))
                .padding(5)
                .background(.green)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        }
    }
}

#Preview {
    ProductCellView(product: Product(title: "new", price: 2.3, description: "new description", images: [ "https://placeimg.com/640/480/any?r=0.9178516507833767"], category: Category(id: 1, name: "new", image: "https://placeimg.com/640/480/any?r=0.9178516507833767")))
}
