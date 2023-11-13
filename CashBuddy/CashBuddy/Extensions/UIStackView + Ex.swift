//
//  UIStackView + Ex.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 16.09.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
