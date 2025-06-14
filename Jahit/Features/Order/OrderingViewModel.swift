//
//  OrderingViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI
import Combine

class OrderingViewModel: ObservableObject {
    @Published var order = NewOrder(
        tailorName: "Alfa Tailor",
        address: "Jalan Ganesha, Bandung",
        items: [OrderSummaryItem(name: "Blazer", quantity: 1, price: 180000)]
    )
    @Published var showingDatePicker: Bool = false
    @Published var showingTimePicker: Bool = false
    @Published var selectedPaymentMethod: PaymentMethod = .creditCard
    
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
    
    func selectPaymentMethod(_ method: PaymentMethod) {
        selectedPaymentMethod = method
        order.paymentMethod = method
    }
    
    func confirmOrder() {
        print("Order confirmed with payment method: \(selectedPaymentMethod.displayName)")
    }
}
