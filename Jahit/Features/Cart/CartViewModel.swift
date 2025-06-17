//
//  CartViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI
import Combine
import Foundation

class CartViewModel: ObservableObject {
    @Published var tailorCarts: [TailorCart] = []
    @Published var isSelectAll: Bool = false
    @Published var showingCustomization: Bool = false
    
    init() {
        let grouped = Dictionary(grouping: CartItem.sampleItems) { $0.tailorId }
        self.tailorCarts = grouped.map { (tailorId, items) in
            let tailor = Tailor(id: tailorId, name: items.first?.tailorName ?? "", profileImage: "", location: "", rating: 0, maxRating: 5, services: [], reviews: [], description: "", locationDescription: "")
            return TailorCart(id: tailorId, tailor: tailor, items: items)
        }
    }
    
    var selectedItems: [CartItem] {
        tailorCarts.flatMap { $0.items.filter { $0.isSelected } }
    }
    
    var totalPrice: Double {
        selectedItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        NumberFormatter.currencyFormatter.string(from: NSNumber(value: totalPrice)) ?? "Rp0"
    }
    
    var hasSelectedItems: Bool {
        !selectedItems.isEmpty
    }
    
    func toggleSelectAll() {
        isSelectAll.toggle()
        for i in tailorCarts.indices {
            for j in tailorCarts[i].items.indices {
                tailorCarts[i].items[j].isSelected = isSelectAll
            }
        }
    }
    
    func toggleSelectAll(for tailorId: String) {
        guard let i = tailorCarts.firstIndex(where: { $0.id == tailorId }) else { return }
        tailorCarts[i].isSelectAll.toggle()
        for j in tailorCarts[i].items.indices {
            tailorCarts[i].items[j].isSelected = tailorCarts[i].isSelectAll
        }
    }
    
    func toggleItemSelection(item: CartItem) {
        for i in tailorCarts.indices {
            if let j = tailorCarts[i].items.firstIndex(where: { $0.id == item.id }) {
                tailorCarts[i].items[j].isSelected.toggle()
                updateSelectAllState(for: tailorCarts[i].id)
            }
        }
    }
    
    func updateQuantity(for item: CartItem, quantity: Int) {
        for i in tailorCarts.indices {
            if let j = tailorCarts[i].items.firstIndex(where: { $0.id == item.id }) {
                tailorCarts[i].items[j].quantity = max(1, quantity)
            }
        }
    }
    
    func removeItem(_ item: CartItem) {
        for i in tailorCarts.indices {
            tailorCarts[i].items.removeAll { $0.id == item.id }
        }
        updateSelectAllState()
    }
    
    func proceedToOrder() {
        if hasSelectedItems {
            showingCustomization = true
        }
    }
    
    private func updateSelectAllState() {
        let allItems = tailorCarts.flatMap { $0.items }
        isSelectAll = !allItems.isEmpty && allItems.allSatisfy { $0.isSelected }
    }
    
    private func updateSelectAllState(for tailorId: String) {
        guard let i = tailorCarts.firstIndex(where: { $0.id == tailorId }) else { return }
        let items = tailorCarts[i].items
        tailorCarts[i].isSelectAll = !items.isEmpty && items.allSatisfy { $0.isSelected }
    }
}
