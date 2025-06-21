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
        // Observe UserManager changes to automatically update UI
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
            return userManager.getOngoingTransactions()
        case .completed:
            return userManager.getCompletedTransactions()
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
}
