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
        } else {
            // If no saved user data, use default user with sample transactions
            currentUser = User.defaultUser
            saveUserToStorage()
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
    
    
    func addToCart(_ item: CartItem) {
        // Check if tailor cart already exists
        if let tailorCartIndex = currentUser.cart.firstIndex(where: { $0.tailorId == item.tailorId }) {
            // Check if same item already exists
            if let itemIndex = currentUser.cart[tailorCartIndex].items.firstIndex(where: { $0.itemId == item.itemId && $0.isCustomOrder == item.isCustomOrder }) {
                // Update quantity for existing item
                currentUser.cart[tailorCartIndex].items[itemIndex].quantity += item.quantity
            } else {
                // Add new item to existing tailor cart
                currentUser.cart[tailorCartIndex].items.append(item)
            }
        } else {
            // Create new tailor cart
            let newTailorCart = TailorCart(tailorId: item.tailorId, tailorName: item.tailorName, items: [item])
            currentUser.cart.append(newTailorCart)
        }
        
        saveUserToStorage()
        print("Added item to cart: \(item.itemName)")
    }
    
    func addCustomizationToCart(_ customizationOrder: CustomizationOrder) {
        guard let cartItem = CartItem.fromCustomizationOrder(customizationOrder) else {
            print("Failed to create cart item from customization order")
            return
        }
        
        addToCart(cartItem)
        print("Added customization to cart: \(cartItem.itemName)")
    }
    
    func removeFromCart(itemId: String, tailorId: String) {
        guard let tailorCartIndex = currentUser.cart.firstIndex(where: { $0.tailorId == tailorId }) else { return }
        
        currentUser.cart[tailorCartIndex].items.removeAll { $0.id == itemId }
        
        // Remove tailor cart if no items left
        if currentUser.cart[tailorCartIndex].items.isEmpty {
            currentUser.cart.remove(at: tailorCartIndex)
        }
        
        saveUserToStorage()
        print("Removed item from cart")
    }
    
    func updateCartItemQuantity(itemId: String, tailorId: String, quantity: Int) {
        guard let tailorCartIndex = currentUser.cart.firstIndex(where: { $0.tailorId == tailorId }),
              let itemIndex = currentUser.cart[tailorCartIndex].items.firstIndex(where: { $0.id == itemId }) else { return }
        
        if quantity <= 0 {
            removeFromCart(itemId: itemId, tailorId: tailorId)
        } else {
            currentUser.cart[tailorCartIndex].items[itemIndex].quantity = quantity
            saveUserToStorage()
        }
    }
    
    func toggleCartItemSelection(itemId: String, tailorId: String) {
        guard let tailorCartIndex = currentUser.cart.firstIndex(where: { $0.tailorId == tailorId }),
              let itemIndex = currentUser.cart[tailorCartIndex].items.firstIndex(where: { $0.id == itemId }) else { return }
        
        currentUser.cart[tailorCartIndex].items[itemIndex].isSelected.toggle()
        saveUserToStorage()
    }
    
    func toggleSelectAllForTailor(tailorId: String) {
        guard let tailorCartIndex = currentUser.cart.firstIndex(where: { $0.tailorId == tailorId }) else { return }
        
        let newSelectionState = !currentUser.cart[tailorCartIndex].isSelectAll
        currentUser.cart[tailorCartIndex].isSelectAll = newSelectionState
        
        for itemIndex in currentUser.cart[tailorCartIndex].items.indices {
            currentUser.cart[tailorCartIndex].items[itemIndex].isSelected = newSelectionState
        }
        
        saveUserToStorage()
    }
    
    func clearCart() {
        currentUser.cart.removeAll()
        saveUserToStorage()
        print("Cart cleared")
    }
    
    func getCartItemsCount() -> Int {
        return currentUser.totalCartItems
    }
    
    func getSelectedCartItems() -> [CartItem] {
        return currentUser.selectedCartItems
    }
    
    func createTransactionFromCart(
        selectedItems: [CartItem],
        pickupDate: Date,
        pickupTime: TimeSlot,
        paymentMethod: PaymentMethod
    ) -> Bool {
        guard !selectedItems.isEmpty,
              let userAddress = currentUser.address else {
            print("Cannot create transaction: missing items or address")
            return false
        }
        
        // Group items by tailor
        let groupedItems = Dictionary(grouping: selectedItems, by: { $0.tailorId })
        
        // Create a transaction for each tailor
        for (tailorId, items) in groupedItems {
            guard let firstItem = items.first else { continue }
            
            let transactionItems = items.map { TransactionItem(from: $0) }
            let totalPrice = items.reduce(0) { $0 + $1.totalPrice }
            
            let transaction = Transaction(
                id: UUID().uuidString,
                tailorId: tailorId,
                tailorName: firstItem.tailorName,
                items: transactionItems,
                totalPrice: totalPrice,
                pickupDate: pickupDate,
                pickupTime: pickupTime.displayName,
                paymentMethod: paymentMethod.displayName,
                customerAddress: userAddress,
                orderDate: Date(),
                status: .pending
            )
            
            currentUser.transactions.append(transaction)
        }
        
        // Remove items from cart
        for item in selectedItems {
            removeFromCart(itemId: item.id, tailorId: item.tailorId)
        }
        
        saveUserToStorage()
        print("Created \(groupedItems.count) transactions from cart")
        return true
    }
    
    func createTransactionFromCustomization(
        _ customizationOrder: CustomizationOrder,
        pickupDate: Date,
        pickupTime: TimeSlot,
        paymentMethod: PaymentMethod
    ) -> Bool {
        guard let userAddress = currentUser.address else {
            print("Cannot create transaction: missing address")
            return false
        }
        
        // Calculate the total price from the selected item and quantity
        let basePrice = customizationOrder.selectedItem?.price ?? 0
        let totalPrice = basePrice * Double(customizationOrder.quantity)
        
        let transactionItem = TransactionItem(
            id: UUID().uuidString,
            name: customizationOrder.selectedItem?.name ?? customizationOrder.category,
            category: customizationOrder.category,
            quantity: customizationOrder.quantity,
            basePrice: basePrice,
            totalPrice: totalPrice,
            isCustomOrder: true,
            customDescription: customizationOrder.description.isEmpty ? nil : customizationOrder.description,
            referenceImages: customizationOrder.referenceImages
        )
        
        let transaction = Transaction(
            id: UUID().uuidString,
            tailorId: customizationOrder.tailorId,
            tailorName: customizationOrder.tailorName,
            items: [transactionItem],
            totalPrice: totalPrice,
            pickupDate: pickupDate,
            pickupTime: pickupTime.displayName,
            paymentMethod: paymentMethod.displayName,
            customerAddress: userAddress,
            orderDate: Date(),
            status: .pending
        )
        
        currentUser.transactions.append(transaction)
        saveUserToStorage()
        print("Created transaction from customization order")
        return true
    }
    
    func updateTransactionStatus(transactionId: String, newStatus: TransactionStatus) {
        guard let index = currentUser.transactions.firstIndex(where: { $0.id == transactionId }) else {
            print("Transaction not found")
            return
        }
        
        currentUser.transactions[index].status = newStatus
        saveUserToStorage()
        print("Updated transaction status to \(newStatus.rawValue)")
    }
    
    func getOngoingTransactions() -> [Transaction] {
        return currentUser.ongoingTransactions
    }
    
    func getCompletedTransactions() -> [Transaction] {
        return currentUser.completedTransactions
    }
    

    
    func addReviewToTransaction(review: Review) {
        guard let index = currentUser.transactions.firstIndex(where: { $0.id == review.transactionId }) else {
            print("Transaction not found for review: \(review.transactionId)")
            return
        }
        
        currentUser.transactions[index].review = review
        saveUserToStorage()
        
        // Trigger published property update for UI refresh
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        
        // Also add the review to the tailor
        print("✅ Adding review to transaction \(review.transactionId)")
        print("📝 Review content: \(review.rating) stars - \(review.comment)")
        LocalDatabase.shared.addReviewToTailor(tailorId: review.tailorId, review: review)
        
        print("✅ Review added to transaction \(review.transactionId) and tailor \(review.tailorId)")
    }
    
    func getReviewForTransaction(transactionId: String) -> Review? {
        return currentUser.transactions.first { $0.id == transactionId }?.review
    }
    
    func hasReviewForTransaction(transactionId: String) -> Bool {
        return getReviewForTransaction(transactionId: transactionId) != nil
    }
    
    func resetToDefaultUserWithSampleData() {
        currentUser = User.defaultUser
        saveUserToStorage()
        print("User reset to default with sample transactions")
    }
}
