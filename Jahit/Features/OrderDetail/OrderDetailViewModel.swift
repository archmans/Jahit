//
//  TransactionDetailViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 12/06/25.
//

import SwiftUI
import Combine

class OrderDetailViewModel: ObservableObject {
    @Published var order: Order
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(order: Order = Order.sampleOrder) {
        self.order = order
    }
    
    var formattedTotalAmount: String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: order.totalAmount)) ?? "Rp0"
    }
    
    var formattedPaymentTime: String {
        return DateFormatter.orderDateFormatter.string(from: order.paymentTime)
    }
    
    var formattedConfirmationTime: String {
        return DateFormatter.orderDateFormatter.string(from: order.confirmationTime)
    }
    
    var currentStepIndex: Int {
        return order.status.stepIndex
    }
    
    func refreshOrder() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
    
    func goBack() {
        print("Going back...")
    }
}
