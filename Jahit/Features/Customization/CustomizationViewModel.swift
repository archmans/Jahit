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
    @Published var showingCartSuccess: Bool = false
    @Published var selectedImages: [UIImage] = []
    @Published var isUploadingImages: Bool = false
    
    private let userManager = UserManager.shared
    private let imageManager = ImageManager.shared
    
    init(tailor: Tailor, service: TailorService, preSelectedProduct: ProductSearchResult? = nil) {
        self.customizationOrder = CustomizationOrder(
            tailorId: tailor.id,
            tailorName: tailor.name,
            category: service.name
        )
        self.availableItems = service.items
        
        // Pre-select the product if provided
        if let preSelectedProduct = preSelectedProduct,
           let matchingItem = service.items.first(where: { $0.id == preSelectedProduct.id }) {
            self.customizationOrder.selectedItem = matchingItem
        }
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
        guard customizationOrder.isValid else {
            print("Invalid customization order")
            return
        }
        
        userManager.addCustomizationToCart(customizationOrder)
        showingCartSuccess = true
        
        // Auto dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showingCartSuccess = false
        }
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
    
    func uploadImages(_ images: [UIImage]) {
        guard !images.isEmpty else { return }
        
        print("Uploading \(images.count) images")
        isUploadingImages = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let savedImageNames = self.imageManager.saveImages(images)
            print("Saved \(savedImageNames.count) images with names: \(savedImageNames)")
            
            DispatchQueue.main.async {
                self.isUploadingImages = false
                
                for imageName in savedImageNames {
                    self.addReferenceImage(imageName)
                }
                
                // Clear selected images after upload
                self.selectedImages.removeAll()
                self.showingImagePicker = false
            }
        }
    }
    
    func uploadSingleImage(_ image: UIImage) {
        uploadImages([image])
    }
    
    func removeReferenceImage(at index: Int) {
        guard index < customizationOrder.referenceImages.count else { return }
        
        let imageName = customizationOrder.referenceImages[index]
        
        // Delete from storage
        _ = imageManager.deleteImage(named: imageName)
        
        // Remove from array
        customizationOrder.referenceImages.remove(at: index)
    }
    
    func clearAllReferenceImages() {
        // Delete all images from storage
        imageManager.deleteImages(named: customizationOrder.referenceImages)
        
        // Clear the array
        customizationOrder.referenceImages.removeAll()
    }
}
