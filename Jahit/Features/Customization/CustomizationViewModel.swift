//
//  CustomizationViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI
import Combine

class CustomizationViewModel: ObservableObject {
    @Published var customizationOrder: CustomizationOrder
    @Published var availableItems: [TailorServiceItem] = []
    @Published var showingItemPicker: Bool = false
    @Published var showingImagePicker: Bool = false
    @Published var showingOrdering: Bool = false
    
    init(tailor: Tailor, service: TailorService) {
        self.customizationOrder = CustomizationOrder(
            tailorId: tailor.id,
            tailorName: tailor.name,
            category: service.name
        )
        self.availableItems = service.items
    }
    
    var selectedItemName: String {
        return customizationOrder.selectedItem?.name ?? "Pilih Item"
    }
    
    var formattedPrice: String {
        guard let item = customizationOrder.selectedItem else { return "Rp0" }
        let totalPrice = item.price * Double(customizationOrder.quantity)
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: totalPrice)) ?? "Rp0"
    }
    
    func selectItem(_ item: TailorServiceItem) {
        customizationOrder.selectedItem = item
        showingItemPicker = false
    }
    
    func updateQuantity(_ quantity: Int) {
        customizationOrder.quantity = max(1, quantity)
    }
    
    func updateDescription(_ description: String) {
        customizationOrder.description = description
    }
    
    func addToCart() {
        print("Adding customization to cart")
    }
    
    func proceedToOrder() {
        if customizationOrder.isValid {
            showingOrdering = true
        }
    }
    
    func addReferenceImage(_ imageName: String) {
        if customizationOrder.referenceImages.count < 10 {
            customizationOrder.referenceImages.append(imageName)
        }
    }
    
    func removeReferenceImage(at index: Int) {
        if index < customizationOrder.referenceImages.count {
            customizationOrder.referenceImages.remove(at: index)
        }
    }
}
