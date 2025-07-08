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
    
    private let userManager = UserManager.shared
    
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
    
    var hasMultipleItems: Bool {
        if let transaction = getOriginalTransaction() {
            return transaction.items.count > 1
        }
        return order.item.contains("Multiple Items")
    }
    
    var itemsList: [String] {
        // Get the actual transaction to display individual items
        if let transaction = getOriginalTransaction() {
            return transaction.items.map { "\($0.name) (x\($0.quantity))" }
        }
        return [order.item]
    }
    
    var transactionItems: [TransactionItem] {
        return getOriginalTransaction()?.items ?? []
    }
    
    var hasCustomItems: Bool {
        return transactionItems.contains { $0.isCustomOrder }
    }
    
    private func getOriginalTransaction() -> Transaction? {
        return userManager.currentUser.transactions.first { $0.id == order.id }
    }
    
    func updateOrderStatus(to newStatus: OrderStatus) {
        // Map OrderStatus back to TransactionStatus and update
        let transactionStatus: TransactionStatus = {
            switch newStatus {
            case .pending:
                return .pending
            case .confirmed:
                return .confirmed
            case .pickup:
                return .pickup
            case .inProgress:
                return .inProgress
            case .onDelivery:
                return .onDelivery
            case .completed:
                return .completed
            }
        }()
        
        userManager.updateTransactionStatus(transactionId: order.id, newStatus: transactionStatus)
        
        // Update local order status
        order.status = newStatus
    }
    
    func refreshOrder() {
        isLoading = true
        // Refresh order from transaction data
        if let transaction = getOriginalTransaction() {
            self.order = transaction.toOrder()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    
    func goBack() {
        print("Going back...")
    }
    
    var orderReview: Review? {
        return getOriginalTransaction()?.review
    }
}
