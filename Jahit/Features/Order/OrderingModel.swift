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
    let tailorId: String
    let tailorLocationDescription: String
    var address: String
    var pickupDate: Date? = nil
    var pickupTime: TimeSlot? = nil
    let items: [OrderSummaryItem]
    var paymentMethod: PaymentMethod? = nil
    var deliveryOption: DeliveryOption? = nil
    
    var totalAmount: Double {
        let itemsTotal = items.reduce(0) { $0 + $1.totalPrice }
        let deliveryCost = deliveryOption?.additionalCost ?? 0
        return itemsTotal + deliveryCost
    }
}

struct OrderSummaryItem {
    let name: String
    let quantity: Int
    let price: Double
    let fabricProvider: FabricProvider?
    let selectedFabricOption: FabricOption?
    let fabricPrice: Double
    
    var totalPrice: Double {
        return Double(quantity) * (price + fabricPrice)
    }
    
    var basePrice: Double {
        return Double(quantity) * price
    }
    
    var totalFabricPrice: Double {
        return Double(quantity) * fabricPrice
    }
}

enum DeliveryOption: String, CaseIterable, Codable {
    case delivery = "Diantar"
    case pickup = "Ambil sendiri"
    
    var displayName: String {
        return self.rawValue
    }
    
    var additionalCost: Double {
        switch self {
        case .delivery: return 15000
        case .pickup: return 0
        }
    }
    
    var description: String {
        switch self {
        case .delivery: return "Diantar"
        case .pickup: return "Ambil sendiri"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .delivery: return "Pesanan diantar ke rumah anda"
        case .pickup: return nil
        }
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

enum PaymentMethod: String, CaseIterable, Hashable {
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
