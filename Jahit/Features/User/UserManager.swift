//
//  UserManager.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/06/25.
//

import SwiftUI
import CoreLocation
import Combine
import CryptoKit

class UserManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = UserManager()
    
    @Published var currentUser: User = User.defaultUser
    @Published var isLocationLoading: Bool = false
    @Published var locationError: String?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    private let registeredUsersKey = "registeredUsers"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        loadUserFromStorage()
    }
    
    // Generate a 9-character order number with digits and letters
    private func generateOrderNumber() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var result = ""
        
        for _ in 0..<9 {
            let randomIndex = Int.random(in: 0..<characters.count)
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            result.append(randomCharacter)
        }
        
        return result
    }
    
    func registerUser(email: String, phoneNumber: String, password: String) {
        let hashedPassword = hashPassword(password)
        
        let userName = email.components(separatedBy: "@").first?.capitalized ?? "User"
        
        let newUser = User(
            name: userName,
            email: email,
            phoneNumber: phoneNumber,
            transactions: User.defaultUser.transactions,
            isLoggedIn: false,
            authProvider: "email",
            hashedPassword: hashedPassword
        )
        
        // Save to registered users list only, don't set as current user
        saveRegisteredUser(newUser)
    }
    
    func loginWithSocialProvider(provider: AuthenticationProvider, email: String, name: String, phoneNumber: String) {
        let newUser = User(
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            transactions: User.defaultUser.transactions,
            isLoggedIn: true,
            authProvider: provider == .google ? "google" : "apple"
        )
        
        currentUser = newUser
        saveUserToStorage()
    }
    
    func logout() {
        currentUser.isLoggedIn = false
        currentUser = User.defaultUser
        saveUserToStorage()
    }
    
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func saveRegisteredUser(_ user: User) {
        var registeredUsers = getRegisteredUsers()
        registeredUsers.append(user)
        
        if let data = try? JSONEncoder().encode(registeredUsers) {
            userDefaults.set(data, forKey: registeredUsersKey)
        }
    }
    
    private func getRegisteredUsers() -> [User] {
        guard let data = userDefaults.data(forKey: registeredUsersKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return []
        }
        return users
    }
    
    private func findRegisteredUser(identifier: String, password: String) -> User? {
        let registeredUsers = getRegisteredUsers()
        return registeredUsers.first { user in
            (user.email?.lowercased() == identifier.lowercased() || user.phoneNumber == identifier) &&
            user.hashedPassword == password
        }
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
    
    func hasValidLocation() -> Bool {
        return currentUser.hasLocation
    }
    
    
    func addToCart(_ item: CartItem) {
        // Check if tailor cart already exists
        if let tailorCartIndex = currentUser.cart.firstIndex(where: { $0.tailorId == item.tailorId }) {
            // Check if same item already exists (including fabric selection)
            if let itemIndex = currentUser.cart[tailorCartIndex].items.firstIndex(where: { 
                $0.itemId == item.itemId && 
                $0.isCustomOrder == item.isCustomOrder &&
                $0.fabricProvider == item.fabricProvider &&
                $0.selectedFabricOption?.id == item.selectedFabricOption?.id
            }) {
                // Update quantity for existing item with same fabric
                currentUser.cart[tailorCartIndex].items[itemIndex].quantity += item.quantity
            } else {
                // Add new item to existing tailor cart (different fabric or new item)
                currentUser.cart[tailorCartIndex].items.append(item)
            }
            
            // Update tailor's isSelectAll based on item selections
            let tailorCart = currentUser.cart[tailorCartIndex]
            let selectedItemsCount = tailorCart.items.filter { $0.isSelected }.count
            let totalItemsCount = tailorCart.items.count
            
            currentUser.cart[tailorCartIndex].isSelectAll = (selectedItemsCount == totalItemsCount && totalItemsCount > 0)
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
        } else {
            // Update tailor's isSelectAll based on remaining items
            let tailorCart = currentUser.cart[tailorCartIndex]
            let selectedItemsCount = tailorCart.items.filter { $0.isSelected }.count
            let totalItemsCount = tailorCart.items.count
            
            currentUser.cart[tailorCartIndex].isSelectAll = (selectedItemsCount == totalItemsCount && totalItemsCount > 0)
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
        
        // Update tailor's isSelectAll based on item selections
        let tailorCart = currentUser.cart[tailorCartIndex]
        let selectedItemsCount = tailorCart.items.filter { $0.isSelected }.count
        let totalItemsCount = tailorCart.items.count
        
        // If all items are selected, set isSelectAll to true
        // If no items are selected, set isSelectAll to false
        // If some items are selected, set isSelectAll to false (partial selection)
        currentUser.cart[tailorCartIndex].isSelectAll = (selectedItemsCount == totalItemsCount && totalItemsCount > 0)
        
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
        paymentMethod: PaymentMethod,
        deliveryOption: DeliveryOption
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
            let itemsTotal = items.reduce(0) { $0 + $1.totalPrice }
            let deliveryCost = deliveryOption.additionalCost
            let totalWithDelivery = itemsTotal + deliveryCost
            
            let transaction = Transaction(
                id: generateOrderNumber(),
                tailorId: tailorId,
                tailorName: firstItem.tailorName,
                items: transactionItems,
                totalPrice: totalWithDelivery,
                pickupDate: pickupDate,
                pickupTime: pickupTime.displayName,
                paymentMethod: paymentMethod.displayName,
                customerAddress: userAddress,
                orderDate: Date(),
                status: .pending,
                review: nil,
                deliveryOption: deliveryOption,
                deliveryCost: deliveryCost
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
        paymentMethod: PaymentMethod,
        deliveryOption: DeliveryOption
    ) -> Bool {
        guard let userAddress = currentUser.address else {
            print("Cannot create transaction: missing address")
            return false
        }
        
        // Calculate prices including fabric
        let basePrice = customizationOrder.selectedItem?.price ?? 0
        let fabricPrice = (!customizationOrder.isRepairService && customizationOrder.fabricProvider == .tailor) ? 
            (customizationOrder.selectedFabricOption?.additionalPrice ?? 0) : 0
        let totalItemPrice = (basePrice + fabricPrice) * Double(customizationOrder.quantity)
        let deliveryCost = deliveryOption.additionalCost
        let finalTotalPrice = totalItemPrice + deliveryCost
        
        let transactionItem = TransactionItem(
            id: generateOrderNumber(),
            name: customizationOrder.selectedItem?.name ?? customizationOrder.category,
            category: customizationOrder.category,
            quantity: customizationOrder.quantity,
            basePrice: basePrice,
            totalPrice: totalItemPrice,
            isCustomOrder: true,
            customDescription: customizationOrder.description.isEmpty ? nil : customizationOrder.description,
            referenceImages: customizationOrder.referenceImages,
            fabricProvider: customizationOrder.isRepairService ? nil : customizationOrder.fabricProvider,
            selectedFabricOption: customizationOrder.selectedFabricOption,
            fabricPrice: fabricPrice
        )
        
        let transaction = Transaction(
            id: generateOrderNumber(),
            tailorId: customizationOrder.tailorId,
            tailorName: customizationOrder.tailorName,
            items: [transactionItem],
            totalPrice: finalTotalPrice,
            pickupDate: pickupDate,
            pickupTime: pickupTime.displayName,
            paymentMethod: paymentMethod.displayName,
            customerAddress: userAddress,
            orderDate: Date(),
            status: .pending,
            review: nil,
            deliveryOption: deliveryOption,
            deliveryCost: deliveryCost
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
    
    func isEmailRegistered(_ email: String) -> Bool {
        let registeredUsers = getRegisteredUsers()
        return registeredUsers.contains { user in
            user.email?.lowercased() == email.lowercased()
        }
    }
    
    func isPhoneRegistered(_ phoneNumber: String) -> Bool {
        let registeredUsers = getRegisteredUsers()
        return registeredUsers.contains { user in
            user.phoneNumber == phoneNumber
        }
    }
    
    func authenticateUser(identifier: String, password: String) -> Bool {
        let hashedPassword = hashPassword(password)
        
        // Check registered users
        if let registeredUser = findRegisteredUser(identifier: identifier, password: hashedPassword) {
            var user = registeredUser
            user.isLoggedIn = true
            
            // Ensure user always has example transactions
            if user.transactions.isEmpty {
                user.transactions = User.defaultUser.transactions
            }
            
            currentUser = user
            saveUserToStorage()
            return true
        }
        
        return false
    }
}
