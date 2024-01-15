//
//  UIVIew+Extensions.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 15/1/24.
//

import UIKit

extension UIView {
    /// Add multiple Views
    /// - Parameter views: Collections of views
    func addSubviews(_ views: UIView...) {
        views.forEach({
            self.addSubview($0)
        })
    }
}
