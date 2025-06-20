//
//  UserManager.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/06/25.
//

import SwiftUI
import CoreLocation
import Combine

class UserManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = UserManager()
    
    @Published var currentUser: User = User.defaultUser
    @Published var isLocationLoading: Bool = false
    @Published var locationError: String?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        loadUserFromStorage()
    }
    
    
    func loadUserFromStorage() {
        if let userData = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
        }
    }
    
    func saveUserToStorage() {
        if let userData = try? JSONEncoder().encode(currentUser) {
            userDefaults.set(userData, forKey: userKey)
        }
    }
    
    func updateUser(name: String? = nil, email: String? = nil, phoneNumber: String? = nil) {
        if let name = name { currentUser.name = name }
        if let email = email { currentUser.email = email }
        if let phoneNumber = phoneNumber { currentUser.phoneNumber = phoneNumber }
        saveUserToStorage()
    }
    
    
    func requestLocationOnAppLaunch() {
        // Only request location if we don't have it yet
        guard !currentUser.hasLocation else { 
            print("User already has location: \(currentUser.address ?? "Unknown")")
            return 
        }
        
        checkLocationAuthorization()
    }
    
    func forceUpdateLocation() {
        // Force update location even if we already have it
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationError = "Location access denied. Please enable location in Settings."
        case .authorizedWhenInUse, .authorizedAlways:
            isLocationLoading = true
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        locationManager.stopUpdatingLocation()
        
        currentUser.latitude = location.coordinate.latitude
        currentUser.longitude = location.coordinate.longitude
        
        fetchAddress(from: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLocationLoading = false
        locationError = "Failed to get location: \(error.localizedDescription)"
        print("Location error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if isLocationLoading {
                locationManager.startUpdatingLocation()
            }
        case .restricted, .denied:
            isLocationLoading = false
            locationError = "Location access denied"
        default:
            break
        }
    }
    
    private func fetchAddress(from location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                self?.isLocationLoading = false
                
                guard error == nil, let placemark = placemarks?.first else {
                    self?.locationError = "Failed to get address"
                    return
                }
                
                // Format address in Indonesian style: "Jl. Nama Jalan No. XX, Desa/Kelurahan"
                let street = placemark.thoroughfare ?? ""
                let number = placemark.subThoroughfare ?? ""
                let subLocality = placemark.subLocality ?? ""
                let locality = placemark.locality ?? ""
                
                var addressComponents: [String] = []
                
                // Format street address
                if !street.isEmpty {
                    var streetPart = ""
                    
                    // Add "Jl. " prefix if not already present
                    if !street.lowercased().hasPrefix("jl") && !street.lowercased().hasPrefix("jalan") {
                        streetPart = "Jl \(street)"
                    } else {
                        streetPart = street
                    }
                    
                    // Add house number if available
                    if !number.isEmpty {
                        streetPart += " No. \(number)"
                    }
                    
                    addressComponents.append(streetPart)
                }
                
                // Add sub-locality (usually village/kelurahan)
                if !subLocality.isEmpty {
                    addressComponents.append(subLocality)
                }
                
                // Add locality (usually city/district) if different from sub-locality
                if !locality.isEmpty && locality != subLocality {
                    addressComponents.append(locality)
                }
                
                let formattedAddress = addressComponents.joined(separator: ", ")
                
                // Update user address
                self?.currentUser.address = formattedAddress.isEmpty ? "Unknown Location" : formattedAddress
                self?.saveUserToStorage()
                
                print("Address updated: \(self?.currentUser.address ?? "Unknown")")
            }
        }
    }
    
    
    func clearLocationData() {
        currentUser.address = nil
        currentUser.latitude = nil
        currentUser.longitude = nil
        saveUserToStorage()
        print("Location data cleared")
    }
    
    func hasValidLocation() -> Bool {
        return currentUser.hasLocation
    }
}
