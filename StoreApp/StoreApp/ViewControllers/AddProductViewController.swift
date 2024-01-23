//
//  AddProductViewController.swift
//  StoreApp
//
//  Created by Carlos Paredes on 22/1/24.
//

import Foundation
import UIKit
import SwiftUI

class AddProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}

struct AddProductViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        AddProductViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct AddProductViewController_Preview: PreviewProvider {
    static var previews: some View {
        AddProductViewControllerRepresentable()
    }
}


