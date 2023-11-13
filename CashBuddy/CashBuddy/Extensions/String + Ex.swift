//
//  String + Ex.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 21.09.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
