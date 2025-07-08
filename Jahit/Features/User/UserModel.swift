//
//  UserModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/06/25.
//

import Foundation
import CoreLocation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String?
    var phoneNumber: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var profileImage: String?
    var cart: [TailorCart] = []
    var transactions: [Transaction] = []
    var isLoggedIn: Bool = false
    var authProvider: String?
    var hashedPassword: String?
    
    init(
        id: String = UUID().uuidString,
        name: String = "User",
        email: String? = nil,
        phoneNumber: String? = nil,
        address: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        profileImage: String? = nil,
        cart: [TailorCart] = [],
        transactions: [Transaction] = [],
        isLoggedIn: Bool = false,
        authProvider: String? = nil,
        hashedPassword: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.profileImage = profileImage
        self.cart = cart
        self.transactions = transactions
        self.isLoggedIn = isLoggedIn
        self.authProvider = authProvider
        self.hashedPassword = hashedPassword
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var hasLocation: Bool {
        return latitude != nil && longitude != nil && address != nil
    }
    
    // Cart related computed properties
    var totalCartItems: Int {
        return cart.reduce(0) { $0 + $1.items.count }
    }
    
    var totalCartPrice: Double {
        return cart.reduce(0) { $0 + $1.totalPrice }
    }
    
    var selectedCartItems: [CartItem] {
        return cart.flatMap { $0.items.filter { $0.isSelected } }
    }
    
    // Transaction related computed properties
    var ongoingTransactions: [Transaction] {
        return transactions.filter { $0.isOngoing }
    }
    
    var completedTransactions: [Transaction] {
        return transactions.filter { $0.isCompleted }
    }
}

extension User {
    static let defaultUser = User(
        name: "Guest User",
        address: "Location not set",
        transactions: [
            // Completed transaction
            Transaction(
                id: "TXN-001",
                tailorId: "1",
                tailorName: "Alfa Tailor",
                items: [
                    TransactionItem(
                        id: "item-1",
                        name: "Blazer Formal",
                        category: "Atasan",
                        quantity: 1,
                        basePrice: 150000,
                        totalPrice: 150000,
                        isCustomOrder: true,
                        customDescription: "Blazer formal untuk acara resmi, warna navy dengan kancing emas",
                        referenceImages: ["blazer", "atasan"]
                    ),
                    TransactionItem(
                        id: "item-2",
                        name: "Celana Bahan",
                        category: "Bawahan",
                        quantity: 1,
                        basePrice: 100000,
                        totalPrice: 100000,
                        isCustomOrder: false,
                        customDescription: nil,
                        referenceImages: ["bawahan"]
                    )
                ],
                totalPrice: 250000,
                pickupDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                pickupTime: "14:00",
                paymentMethod: "GoPay",
                customerAddress: "Jl. Ganesha No. 10, Bandung",
                orderDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
                status: .completed
            ),
            
            // In progress transaction
            Transaction(
                id: "TXN-002",
                tailorId: "2",
                tailorName: "Beta Tailor",
                items: [
                    TransactionItem(
                        id: "item-3",
                        name: "Dress Custom",
                        category: "Terusan",
                        quantity: 1,
                        basePrice: 200000,
                        totalPrice: 200000,
                        isCustomOrder: true,
                        customDescription: "Dress untuk pesta pernikahan, model A-line dengan detail bordir di bagian dada",
                        referenceImages: ["terusan", "banner"]
                    )
                ],
                totalPrice: 200000,
                pickupDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                pickupTime: "16:00",
                paymentMethod: "Kartu Debit",
                customerAddress: "Jl. Dipatiukur No. 35, Bandung",
                orderDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                status: .inProgress
            ),
            
            // Ready for pickup transaction
            Transaction(
                id: "TXN-003",
                tailorId: "1",
                tailorName: "Alfa Tailor",
                items: [
                    TransactionItem(
                        id: "item-4",
                        name: "Kemeja Batik",
                        category: "Atasan",
                        quantity: 2,
                        basePrice: 80000,
                        totalPrice: 160000,
                        isCustomOrder: true,
                        customDescription: "Kemeja batik untuk acara formal kantor, motif parang dengan kombinasi warna biru",
                        referenceImages: ["atasan", "blazer"]
                    )
                ],
                totalPrice: 160000,
                pickupDate: Date(),
                pickupTime: "10:00",
                paymentMethod: "GoPay",
                customerAddress: "Jl. Ganesha No. 10, Bandung",
                orderDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                status: .pickup
            ),
            
            // Pending transaction
            Transaction(
                id: "TXN-004",
                tailorId: "3",
                tailorName: "Gamma Tailor",
                items: [
                    TransactionItem(
                        id: "item-5",
                        name: "Jas Pengantin",
                        category: "Atasan",
                        quantity: 1,
                        basePrice: 500000,
                        totalPrice: 500000,
                        isCustomOrder: true,
                        customDescription: "Jas pengantin warna hitam dengan detail emas, menggunakan bahan wool premium",
                        referenceImages: ["blazer", "atasan"]
                    ),
                    TransactionItem(
                        id: "item-6",
                        name: "Celana Jas",
                        category: "Bawahan",
                        quantity: 1,
                        basePrice: 200000,
                        totalPrice: 200000,
                        isCustomOrder: true,
                        customDescription: "Celana jas matching dengan jas pengantin",
                        referenceImages: ["bawahan"]
                    )
                ],
                totalPrice: 700000,
                pickupDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
                pickupTime: "15:00",
                paymentMethod: "Transfer Bank",
                customerAddress: "Jl. Asia Afrika No. 8, Bandung",
                orderDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                status: .pending
            ),
            
            // Another completed transaction
            Transaction(
                id: "TXN-005",
                tailorId: "2",
                tailorName: "Beta Tailor",
                items: [
                    TransactionItem(
                        id: "item-7",
                        name: "Kebaya Modern",
                        category: "Terusan",
                        quantity: 1,
                        basePrice: 300000,
                        totalPrice: 300000,
                        isCustomOrder: true,
                        customDescription: "Kebaya modern untuk wisuda, warna cream dengan detail payet",
                        referenceImages: ["terusan"]
                    )
                ],
                totalPrice: 300000,
                pickupDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
                pickupTime: "13:00",
                paymentMethod: "GoPay",
                customerAddress: "Jl. Dipatiukur No. 35, Bandung",
                orderDate: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date(),
                status: .completed
            )
        ]
    )
}
