//
//  Date + Ex.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.MM.yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}
