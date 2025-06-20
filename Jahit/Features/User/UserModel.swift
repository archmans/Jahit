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
    
    init(
        id: String = UUID().uuidString,
        name: String = "User",
        email: String? = nil,
        phoneNumber: String? = nil,
        address: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        profileImage: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.profileImage = profileImage
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var hasLocation: Bool {
        return latitude != nil && longitude != nil && address != nil
    }
}

extension User {
    static let defaultUser = User(
        name: "Guest User",
        address: "Location not set"
    )
}
