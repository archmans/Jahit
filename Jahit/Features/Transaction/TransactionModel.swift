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

enum TransactionStatus: String, Codable {
    case pending = "Menunggu Konfirmasi"
    case confirmed = "Dikonfirmasi"
    case inProgress = "Sedang Dikerjakan"
    case readyForPickup = "Siap Diambil"
    case completed = "Selesai"
    case cancelled = "Dibatalkan"
}

struct TransactionItem: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let quantity: Int
    let basePrice: Double
    let totalPrice: Double
    let isCustomOrder: Bool
    let customDescription: String?
    let referenceImages: [String]
    
    init(
        id: String,
        name: String,
        category: String,
        quantity: Int,
        basePrice: Double,
        totalPrice: Double,
        isCustomOrder: Bool,
        customDescription: String? = nil,
        referenceImages: [String] = []
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.quantity = quantity
        self.basePrice = basePrice
        self.totalPrice = totalPrice
        self.isCustomOrder = isCustomOrder
        self.customDescription = customDescription
        self.referenceImages = referenceImages
    }
    
    init(from cartItem: CartItem) {
        self.id = cartItem.id
        self.name = cartItem.itemName
        self.category = cartItem.category
        self.quantity = cartItem.quantity
        self.basePrice = cartItem.basePrice
        self.totalPrice = cartItem.totalPrice
        self.isCustomOrder = cartItem.isCustomOrder
        self.customDescription = cartItem.customDescription
        self.referenceImages = cartItem.referenceImages
    }
}

struct Transaction: Identifiable, Codable {
    let id: String
    let tailorId: String
    let tailorName: String
    let items: [TransactionItem]
    let totalPrice: Double
    let pickupDate: Date
    let pickupTime: String
    let paymentMethod: String
    let customerAddress: String
    let orderDate: Date
    var status: TransactionStatus
    
    var isCompleted: Bool {
        return status == .completed
    }
    
    var isOngoing: Bool {
        return ![.completed, .cancelled].contains(status)
    }
    
    var formattedOrderDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: orderDate)
    }
    
    var formattedPickupDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: pickupDate)
    }
    
    var itemsSummary: String {
        let itemNames = items.map { $0.name }
        return itemNames.joined(separator: ", ")
    }
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
