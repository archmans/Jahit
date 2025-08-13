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
    
    private func calculateTotalAmount(for transaction: Transaction) -> Double {
        return transaction.items.reduce(0) { total, item in
            total + item.priceEstimate.minPrice
        }
    }
    
    private func calculateMaxTotalAmount(for transaction: Transaction) -> Double {
        return transaction.items.reduce(0) { total, item in
            total + item.priceEstimate.maxPrice
        }
    }
    
    var formattedTotalAmount: String {
        if let finalPrice = order.finalPrice, order.isPriceConfirmed {
            let totalWithDelivery = finalPrice + order.deliveryCost
            return NumberFormatter.currencyFormatter.string(from: NSNumber(value: totalWithDelivery)) ?? "Rp0"
        }
        
        if let transaction = getOriginalTransaction() {
            let minTotal = calculateTotalAmount(for: transaction) + order.deliveryCost
            let maxTotal = calculateMaxTotalAmount(for: transaction) + order.deliveryCost
            
            let minFormatted = NumberFormatter.currencyFormatter.string(from: NSNumber(value: minTotal)) ?? "Rp0"
            let maxFormatted = NumberFormatter.currencyFormatter.string(from: NSNumber(value: maxTotal)) ?? "Rp0"
            
            return "\(minFormatted) - \(maxFormatted)"
        }
        
        return "Rp0"
    }
    
    var proposedFinalPrice: Double {
        if let transaction = getOriginalTransaction() {
            let minTotal = calculateTotalAmount(for: transaction)
            let maxTotal = calculateMaxTotalAmount(for: transaction)
            let avgTotal = (minTotal + maxTotal) / 2
            return avgTotal + order.deliveryCost
        }
        return 0
    }
    
    var formattedProposedFinalPrice: String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: proposedFinalPrice)) ?? "Rp0"
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
    
    var applicableStatuses: [OrderStatus] {
        guard let transaction = getOriginalTransaction() else {
            return OrderStatus.allCases
        }
        
        let baseStatuses: [OrderStatus] = [.pending, .confirmed, .pickup, .inProgress]
        
        if transaction.deliveryOption == .pickup {
            return baseStatuses + [.readyForPickup, .completed]
        } else {
            return baseStatuses + [.onDelivery, .completed]
        }
    }
    
    var hasMultipleItems: Bool {
        if let transaction = getOriginalTransaction() {
            return transaction.items.count > 1
        }
        return order.item.contains("Multiple Items")
    }
    
    var itemsList: [String] {
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
            case .readyForPickup:
                return .readyForPickup
            case .onDelivery:
                return .onDelivery
            case .completed:
                return .completed
            case .cancelled:
                return .cancelled
            }
        }()
        
        userManager.updateTransactionStatus(transactionId: order.id, newStatus: transactionStatus)
        
        order.status = newStatus
    }
    
    func refreshOrder() {
        isLoading = true
        if let transaction = getOriginalTransaction() {
            self.order = transaction.toOrder()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    
    func confirmPrice(_ finalPrice: Double) {
        guard let transaction = getOriginalTransaction(),
              let index = userManager.currentUser.transactions.firstIndex(where: { $0.id == transaction.id }) else {
            return
        }
        
        userManager.currentUser.transactions[index].finalPrice = finalPrice
        userManager.currentUser.transactions[index].isPriceConfirmed = true
        userManager.currentUser.transactions[index].status = .inProgress
        userManager.saveUserToStorage()
        
        order.finalPrice = finalPrice
        order.isPriceConfirmed = true
        order.status = .inProgress
    }
    
    func rejectPrice() {
        guard let transaction = getOriginalTransaction(),
                let index = userManager.currentUser.transactions.firstIndex(where: { $0.id == transaction.id }) else {
            return
        }
        
        userManager.currentUser.transactions[index].status = .cancelled
        userManager.saveUserToStorage()
        
        order.status = .cancelled
    }
    
    func goBack() {
        print("Going back...")
    }
    
    var orderReview: Review? {
        return getOriginalTransaction()?.review
    }
}
