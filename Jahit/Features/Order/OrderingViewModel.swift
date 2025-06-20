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
    @Published var selectedPaymentMethod: PaymentMethod = .creditCard
    
    init(customizationOrder: CustomizationOrder) {
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
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: order.pickupDate)
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
    
    func confirmOrder() {
        print("Order confirmed with payment method: \(selectedPaymentMethod.displayName)")
        print("Total amount: \(formattedTotalPrice)")
        print("Items: \(order.items.map { "\($0.name) x\($0.quantity)" }.joined(separator: ", "))")
    }
}
