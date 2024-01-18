//
//  UIViewController+Extensions.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 17/1/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}
