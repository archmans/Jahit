//
//  OrderingModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import Foundation

struct Ordering: Identifiable {
    let id = UUID()
    let tailorName: String
    var address: String
    var pickupDate: Date = Date()
    var pickupTime: TimeSlot = .morning
    let items: [OrderSummaryItem]
    var paymentMethod: PaymentMethod = .creditCard
    
    var totalAmount: Double {
        return items.reduce(0) { $0 + $1.totalPrice }
    }
}

struct OrderSummaryItem {
    let name: String
    let quantity: Int
    let price: Double
    
    var totalPrice: Double {
        return Double(quantity) * price
    }
}

enum TimeSlot: String, CaseIterable {
    case morning = "08.00-10.00"
    case midMorning = "10.00-12.00"
    case afternoon = "12.00-14.00"
    case midAfternoon = "14.00-16.00"
    case evening = "16.00-18.00"
    
    var displayName: String {
        return self.rawValue
    }
}

enum PaymentMethod: String, CaseIterable {
    case creditCard = "Kartu Kredit Atau Debit"
    case qris = "QRIS"
    case cod = "Tunai/COD"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .creditCard: return "creditcard"
        case .qris: return "qrcode"
        case .cod: return "banknote"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .creditCard: return "Visa / Mastercard"
        case .cod: return "(Pembayaran dilakukan pada saat barang diantar)"
        default: return nil
        }
    }
}
