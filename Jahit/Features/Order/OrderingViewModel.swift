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
        @Published var selectedDeliveryOption: DeliveryOption? = .delivery
    
    private let customizationOrder: CustomizationOrder
    
    init(customizationOrder: CustomizationOrder) {
        self.customizationOrder = customizationOrder
        
        let fabricPrice = (!customizationOrder.isRepairService && customizationOrder.fabricProvider == .tailor) ? 
            (customizationOrder.selectedFabricOption?.additionalPrice ?? 0) : 0
        
        let orderItem = OrderSummaryItem(
            name: customizationOrder.selectedItem?.name ?? "Unknown Item",
            quantity: customizationOrder.quantity,
            price: customizationOrder.selectedItem?.price ?? 0,
            fabricProvider: customizationOrder.isRepairService ? nil : customizationOrder.fabricProvider,
            selectedFabricOption: customizationOrder.selectedFabricOption,
            fabricPrice: fabricPrice
        )
        
        let userAddress = UserManager.shared.currentUser.address ?? "Alamat belum diset"
        
        let tailor = LocalDatabase.shared.getTailor(by: customizationOrder.tailorId)
        let tailorLocationDescription = tailor?.locationDescription ?? "Lokasi tidak tersedia"
        
        self.order = Ordering(
            tailorName: customizationOrder.tailorName,
            tailorId: customizationOrder.tailorId,
            tailorLocationDescription: tailorLocationDescription,
            address: userAddress,
            items: [orderItem]
        )
        
        self.order.deliveryOption = self.selectedDeliveryOption
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
    
    func selectDeliveryOption(_ option: DeliveryOption) {
        selectedDeliveryOption = option
        order.deliveryOption = option
    }
    
    var isFormValid: Bool {
        let hasValidAddress = !(UserManager.shared.currentUser.address?.isEmpty ?? true)
        let hasPickupDate = order.pickupDate != nil
        let hasPickupTime = order.pickupTime != nil
        let hasPaymentMethod = selectedPaymentMethod != nil
        let hasDeliveryOption = selectedDeliveryOption != nil
        
        return hasValidAddress && hasPickupDate && hasPickupTime && hasPaymentMethod && hasDeliveryOption
    }
    
    func confirmOrder() -> Bool {
        guard isFormValid else {
            print("Cannot confirm order: missing required fields")
            return false
        }
        
        guard let pickupDate = order.pickupDate,
                let pickupTime = order.pickupTime,
                let paymentMethod = selectedPaymentMethod,
                let deliveryOption = selectedDeliveryOption else {
            print("Cannot confirm order: missing date, time, payment method, or delivery option")
            return false
        }
        
        let success = UserManager.shared.createTransactionFromCustomization(
            customizationOrder,
            pickupDate: pickupDate,
            pickupTime: pickupTime,
            paymentMethod: paymentMethod,
            deliveryOption: deliveryOption
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
