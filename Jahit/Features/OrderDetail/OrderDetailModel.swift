//
//  TransactionDetailModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 12/06/25.
//

import Foundation

struct Order {
    let id: String
    let tailorName: String
    let category: String
    let item: String
    let referenceImages: [String]
    let description: String
    let paymentMethod: String
    let pickupAddress: String
    let orderNumber: String
    let paymentTime: Date
    let confirmationTime: Date
    let totalAmount: Double
    let status: OrderStatus
}

enum OrderStatus: String, CaseIterable {
    case confirmed = "Pesanan dikonfirmasi"
    case inProgress = "Sedang dijahit"
    case shipping = "Sedang dikirim"
    case completed = "Pesanan Selesai"
    
    var stepIndex: Int {
        switch self {
        case .confirmed: return 0
        case .inProgress: return 1
        case .shipping: return 2
        case .completed: return 3
        }
    }
    
    var icon: String {
        switch self {
        case .confirmed: return "doc.text"
        case .inProgress: return "scissors"
        case .shipping: return "checkmark.shield"
        case .completed: return "checkmark.circle"
        }
    }
}

extension Order {
    static let sampleOrder = Order(
        id: "123456789",
        tailorName: "Alfa Tailor",
        category: "Atasan",
        item: "Blazer",
        referenceImages: ["blazer", "blazer"],
        description: "-",
        paymentMethod: "Kartu Debit",
        pickupAddress: "Jalan Ganesha, Bandung",
        orderNumber: "123456789",
        paymentTime: DateFormatter.orderDateFormatter.date(from: "09-05-2025 10:00") ?? Date(),
        confirmationTime: DateFormatter.orderDateFormatter.date(from: "09-05-2025 11:00") ?? Date(),
        totalAmount: 200000,
        status: .inProgress
    )
}

extension DateFormatter {
    static let orderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }()
}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
