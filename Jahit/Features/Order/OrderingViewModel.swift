//
//  OrderingViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI
import Combine

class OrderingViewModel: ObservableObject {
    @Published var order: Ordering
    @Published var showingDatePicker: Bool = false
    @Published var showingTimePicker: Bool = false
    @Published var selectedPaymentMethod: PaymentMethod? = nil
    
    private let customizationOrder: CustomizationOrder
    
    init(customizationOrder: CustomizationOrder) {
        self.customizationOrder = customizationOrder
        
        let orderItem = OrderSummaryItem(
            name: customizationOrder.selectedItem?.name ?? "Unknown Item",
            quantity: customizationOrder.quantity,
            price: customizationOrder.selectedItem?.price ?? 0
        )
        
        // Try to get user's current address, fallback to default
        let userAddress = UserManager.shared.currentUser.address ?? "Alamat belum diset"
        
        self.order = Ordering(
            tailorName: customizationOrder.tailorName,
            address: userAddress,
            items: [orderItem]
        )
    }
    
    var formattedPickupDate: String {
        guard let pickupDate = order.pickupDate else {
            return "Belum dipilih"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: pickupDate)
    }
    
    var formattedTotalPrice: String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: order.totalAmount)) ?? "Rp0"
    }
    
    func updatePickupDate(_ date: Date) {
        order.pickupDate = date
        showingDatePicker = false
    }
    
    func updatePickupTime(_ timeSlot: TimeSlot) {
        order.pickupTime = timeSlot
        showingTimePicker = false
    }
    
    func updateAddress(_ address: String) {
        order.address = address
    }
    
    func selectPaymentMethod(_ method: PaymentMethod) {
        selectedPaymentMethod = method
        order.paymentMethod = method
    }
    
    var isFormValid: Bool {
        let hasValidAddress = !(UserManager.shared.currentUser.address?.isEmpty ?? true)
        let hasPickupDate = order.pickupDate != nil
        let hasPickupTime = order.pickupTime != nil
        let hasPaymentMethod = selectedPaymentMethod != nil
        
        return hasValidAddress && hasPickupDate && hasPickupTime && hasPaymentMethod
    }
    
    func confirmOrder() -> Bool {
        // Validate required fields
        guard isFormValid else {
            print("Cannot confirm order: missing required fields")
            return false
        }
        
        guard let pickupDate = order.pickupDate,
              let pickupTime = order.pickupTime,
              let paymentMethod = selectedPaymentMethod else {
            print("Cannot confirm order: missing date, time, or payment method")
            return false
        }
        
        // Create transaction from customization order
        let success = UserManager.shared.createTransactionFromCustomization(
            customizationOrder,
            pickupDate: pickupDate,
            pickupTime: pickupTime,
            paymentMethod: paymentMethod
        )
        
        if success {
            print("Order confirmed with payment method: \(paymentMethod.displayName)")
            print("Total amount: \(formattedTotalPrice)")
            print("Items: \(order.items.map { "\($0.name) x\($0.quantity)" }.joined(separator: ", "))")
        } else {
            print("Failed to confirm order")
        }
        
        return success
    }
}
