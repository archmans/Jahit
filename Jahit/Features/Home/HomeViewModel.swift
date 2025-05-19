//
//  HomeViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 18/05/25.
//

import SwiftUI
import CoreLocation
import Combine
import Foundation

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var searchText: String = ""
    @Published var formattedAddress: String? = nil
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var locationError: Error?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied"])
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    private func fetchAddress(from location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                DispatchQueue.main.async {
                    self?.formattedAddress = nil
                }
                return
            }
            let street = placemark.thoroughfare ?? ""
            let number = placemark.subThoroughfare ?? ""
            let address = "\(street) no. \(number)"
            DispatchQueue.main.async {
                self?.formattedAddress = address
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        fetchAddress(from: loc)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
        
    
}
