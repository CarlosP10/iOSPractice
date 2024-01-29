//
//  ProductImageViewList.swift
//  StoreApp
//
//  Created by Carlos Paredes on 29/1/24.
//

import SwiftUI

struct ProductImageViewList: View {
    
    let images: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(images,id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }
}

#Preview {
    ProductImageViewList(images: [])
}
