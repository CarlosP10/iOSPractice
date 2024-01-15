//
//  UIStackVIew+Extensions.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 15/1/24.
//

import UIKit

extension UIStackView {
    /// Add multiple Views
    /// - Parameter views: Collections of views
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach({
            self.addArrangedSubview($0)
        })
    }
}
