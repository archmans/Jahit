//
//  TransactionModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 09/06/25.
//

import Foundation

enum TransactionTab: String, CaseIterable, Identifiable {
    case ongoing = "Sedang Berlangsung"
    case completed = "Selesai"

    var id: String { rawValue }
}

struct Transaction: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let imageName: String
    var price: Double
    var isCompleted: Bool
}

extension Double {
    var idrFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = "Rp. "
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: self)) ?? "Rp. \(self)"
    }
}
