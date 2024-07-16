//
//  UIView+Extensions.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.
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
