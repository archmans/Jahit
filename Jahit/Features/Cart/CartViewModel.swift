//
//  CartViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI
import Combine

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = CartItem.sampleItems
    @Published var isSelectAll: Bool = false
    @Published var showingCustomization: Bool = false
    
    var selectedItems: [CartItem] {
        return cartItems.filter { $0.isSelected }
    }
    
    var totalPrice: Double {
        return selectedItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: totalPrice)) ?? "Rp0"
    }
    
    var hasSelectedItems: Bool {
        return !selectedItems.isEmpty
    }
    
    func toggleSelectAll() {
        isSelectAll.toggle()
        for index in cartItems.indices {
            cartItems[index].isSelected = isSelectAll
        }
    }
    
    func toggleItemSelection(item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].isSelected.toggle()
            updateSelectAllState()
        }
    }
    
    func updateQuantity(for item: CartItem, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity = max(1, quantity)
        }
    }
    
    func removeItem(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
        updateSelectAllState()
    }
    
    func proceedToOrder() {
        if hasSelectedItems {
            showingCustomization = true
        }
    }
    
    private func updateSelectAllState() {
        isSelectAll = !cartItems.isEmpty && cartItems.allSatisfy { $0.isSelected }
    }
}
