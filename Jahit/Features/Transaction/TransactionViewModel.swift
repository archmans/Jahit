//
//  TransactionViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 09/06/25.
//

import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published var selectedTab: TransactionTab = .ongoing
    
    private let userManager = UserManager.shared
    
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
}
