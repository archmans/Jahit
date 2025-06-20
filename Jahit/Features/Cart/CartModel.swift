import Foundation

struct CartItem: Identifiable, Codable, Hashable {
    let id: String
    let tailorId: String
    let tailorName: String
    let category: String
    let itemName: String
    let itemId: String
    let image: String
    var quantity: Int
    let basePrice: Double
    var isSelected: Bool = false
    
    // Customization specific properties
    var isCustomOrder: Bool = false
    var customDescription: String?
    var referenceImages: [String] = []
    
    var totalPrice: Double {
        return Double(quantity) * basePrice
    }
    
    init(
        id: String = UUID().uuidString,
        tailorId: String,
        tailorName: String,
        category: String,
        itemName: String,
        itemId: String,
        image: String,
        quantity: Int,
        basePrice: Double,
        isSelected: Bool = false,
        isCustomOrder: Bool = false,
        customDescription: String? = nil,
        referenceImages: [String] = []
    ) {
        self.id = id
        self.tailorId = tailorId
        self.tailorName = tailorName
        self.category = category
        self.itemName = itemName
        self.itemId = itemId
        self.image = image
        self.quantity = quantity
        self.basePrice = basePrice
        self.isSelected = isSelected
        self.isCustomOrder = isCustomOrder
        self.customDescription = customDescription
        self.referenceImages = referenceImages
    }
}

// Helper to create CartItem from CustomizationOrder
extension CartItem {
    static func fromCustomizationOrder(_ order: CustomizationOrder) -> CartItem? {
        guard let selectedItem = order.selectedItem else { return nil }
        
        return CartItem(
            tailorId: order.tailorId,
            tailorName: order.tailorName,
            category: order.category,
            itemName: selectedItem.name,
            itemId: selectedItem.id,
            image: selectedItem.image,
            quantity: order.quantity,
            basePrice: selectedItem.price,
            isCustomOrder: true,
            customDescription: order.description.isEmpty ? nil : order.description,
            referenceImages: order.referenceImages
        )
    }
}

struct TailorCart: Identifiable, Codable {
    let id: String
    let tailorId: String
    let tailorName: String
    var items: [CartItem]
    var isSelectAll: Bool = false
    
    var totalPrice: Double {
        return items.filter { $0.isSelected }.reduce(0) { $0 + $1.totalPrice }
    }
    
    var selectedItemsCount: Int {
        return items.filter { $0.isSelected }.count
    }
    
    init(tailorId: String, tailorName: String, items: [CartItem] = []) {
        self.id = UUID().uuidString
        self.tailorId = tailorId
        self.tailorName = tailorName
        self.items = items
    }
}

extension CartItem {
    static let sampleItems = [
        CartItem(tailorId: "1", tailorName: "Alfa Tailor", category: "Atasan", itemName: "Blazer", itemId: "i3", image: "blazer", quantity: 2, basePrice: 90000),
        CartItem(tailorId: "1", tailorName: "Alfa Tailor", category: "Bawahan", itemName: "Celana", itemId: "i4", image: "bawahan", quantity: 1, basePrice: 75000),
        CartItem(tailorId: "2", tailorName: "Beta Tailor", category: "Atasan", itemName: "Kemeja", itemId: "i1", image: "atasan", quantity: 1, basePrice: 65000),
        CartItem(tailorId: "2", tailorName: "Beta Tailor", category: "Bawahan", itemName: "Celana Pendek", itemId: "i5", image: "bawahan", quantity: 3, basePrice: 60000)
    ]
}
