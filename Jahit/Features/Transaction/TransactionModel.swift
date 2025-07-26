//
//  TransactionModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 09/06/25.
//

import Foundation

enum TransactionTab: String, CaseIterable, Identifiable {
    case ongoing = "Berlangsung"
    case completed = "Selesai"

    var id: String { rawValue }
}

enum TransactionStatus: String, Codable {
    case pending = "Menunggu Konfirmasi"
    case confirmed = "Dikonfirmasi"
    case pickup = "Pengukuran / Pengambilan Bahan"
    case inProgress = "Sedang Dikerjakan"
    case onDelivery = "Pesanan Sedang Diantar"
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
    
    let fabricProvider: FabricProvider?
    let selectedFabricOption: FabricOption?
    let fabricPrice: Double
    
    init(
        id: String,
        name: String,
        category: String,
        quantity: Int,
        basePrice: Double,
        totalPrice: Double,
        isCustomOrder: Bool,
        customDescription: String? = nil,
        referenceImages: [String] = [],
        fabricProvider: FabricProvider? = nil,
        selectedFabricOption: FabricOption? = nil,
        fabricPrice: Double = 0
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
        self.fabricProvider = fabricProvider
        self.selectedFabricOption = selectedFabricOption
        self.fabricPrice = fabricPrice
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
        self.fabricProvider = cartItem.fabricProvider
        self.selectedFabricOption = cartItem.selectedFabricOption
        self.fabricPrice = cartItem.fabricPrice
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
    var review: Review?
    
    var isCompleted: Bool {
        return status == .completed
    }
    
    var isOngoing: Bool {
        return ![.completed, .cancelled].contains(status)
    }
    
    var hasReview: Bool {
        return review != nil
    }
    
    func addingReview(_ review: Review) -> Transaction {
        var updatedTransaction = self
        updatedTransaction.review = review
        return updatedTransaction
    }
}

extension Transaction {
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
    
    // Convert Transaction to Order for OrderDetailView compatibility
    func toOrder() -> Order {
        // Map TransactionStatus to OrderStatus
        let orderStatus: OrderStatus = {
            switch self.status {
            case .pending:
                return .pending
            case .confirmed:
                return .confirmed
            case .pickup:
                return .pickup
            case .inProgress:
                return .inProgress
            case .onDelivery:
                return .onDelivery
            case .completed:
                return .completed
            case .cancelled:
                return .pending
            }
        }()
        
        // Get first item for basic details (can be expanded for multiple items)
        let firstItem = items.first
        let allReferenceImages = items.flatMap { $0.referenceImages }
        let customDescriptions = items.compactMap { $0.customDescription }.joined(separator: "\n")
        
        return Order(
            id: self.id,
            tailorName: self.tailorName,
            category: firstItem?.category ?? "Unknown",
            item: firstItem?.name ?? "Multiple Items",
            referenceImages: allReferenceImages,
            description: customDescriptions.isEmpty ? "-" : customDescriptions,
            paymentMethod: self.paymentMethod,
            pickupAddress: self.customerAddress,
            orderNumber: self.id,
            paymentTime: self.orderDate,
            confirmationTime: self.orderDate,
            totalAmount: self.totalPrice,
            status: orderStatus
        )
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
