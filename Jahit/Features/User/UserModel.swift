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
    
    init(
        id: String = UUID().uuidString,
        name: String = "User",
        email: String? = nil,
        phoneNumber: String? = nil,
        address: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        profileImage: String? = nil,
        cart: [TailorCart] = []
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
}

extension User {
    static let defaultUser = User(
        name: "Guest User",
        address: "Location not set"
    )
}
