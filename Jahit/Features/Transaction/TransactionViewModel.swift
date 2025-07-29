//
//  TransactionViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 09/06/25.
//

import SwiftUI
import Combine

class TransactionViewModel: ObservableObject {
    @Published var selectedTab: TransactionTab = .ongoing
    
    private let userManager = UserManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        userManager.$currentUser
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
    
    var filteredTransactions: [Transaction] {
        switch selectedTab {
        case .ongoing:
            return getOngoingTransactionsSortedByRecent()
        case .completed:
            return getCompletedTransactionsSortedByRecent()
        }
    }
    
    func updateTransactionStatus(transactionId: String, newStatus: TransactionStatus) {
        userManager.updateTransactionStatus(transactionId: transactionId, newStatus: newStatus)
    }
    
    func refreshTransactions() {
        objectWillChange.send()
    }
    
    func loadSampleData() {
        userManager.resetToDefaultUserWithSampleData()
        objectWillChange.send()
    }
    
    func getOngoingTransactionsSortedByRecent() -> [Transaction] {
        return userManager.getOngoingTransactions()
            .sorted { transaction1, transaction2 in
                return transaction1.orderDate > transaction2.orderDate
            }
    }
    
    func getCompletedTransactionsSortedByRecent() -> [Transaction] {
        return userManager.getCompletedTransactions()
            .sorted { transaction1, transaction2 in
                return transaction1.orderDate > transaction2.orderDate
            }
    }
    
    func getAllTransactionsSortedByRecent() -> [Transaction] {
        let allTransactions = userManager.getOngoingTransactions() + userManager.getCompletedTransactions()
        return allTransactions.sorted { transaction1, transaction2 in
            return transaction1.orderDate > transaction2.orderDate
        }
    }
}
