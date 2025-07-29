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
    let deliveryOption: DeliveryOption?
    let deliveryCost: Double
    var status: OrderStatus
}

enum OrderStatus: String, CaseIterable {
    case pending = "Menunggu Konfirmasi"
    case confirmed = "Pesanan dikonfirmasi"
    case pickup = "Pengukuran / Pengambilan Bahan"
    case inProgress = "Sedang dijahit"
    case readyForPickup = "Siap diambil"
    case onDelivery = "Pesanan sedang diantar"
    case completed = "Pesanan Selesai"
    
    var stepIndex: Int {
        switch self {
        case .pending: return 0
        case .confirmed: return 1
        case .pickup: return 2
        case .inProgress: return 3
        case .readyForPickup: return 4
        case .onDelivery: return 4
        case .completed: return 5
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "menunggu_konfirmasi"
        case .confirmed: return "pesanan_dikonfirmasi"
        case .pickup: return "pengukuran"
        case .inProgress: return "dijahit"
        case .readyForPickup: return "diantar"
        case .onDelivery: return "diantar"
        case .completed: return "pesanan_selesai"
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
        orderNumber: "ABC123XYZ",
        paymentTime: DateFormatter.orderDateFormatter.date(from: "09-05-2025 10:00") ?? Date(),
        confirmationTime: DateFormatter.orderDateFormatter.date(from: "09-05-2025 11:00") ?? Date(),
        totalAmount: 200000,
        deliveryOption: .delivery,
        deliveryCost: 15000,
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