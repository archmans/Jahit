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
    
    var isCustomOrder: Bool = false
    var customDescription: String?
    var referenceImages: [String] = []
    
    var fabricProvider: FabricProvider?
    var selectedFabricOption: FabricOption?
    var fabricPrice: Double = 0
    
    var totalPrice: Double {
        let baseCost = Double(quantity) * basePrice
        let fabricCost = Double(quantity) * fabricPrice
        return baseCost + fabricCost
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
        referenceImages: [String] = [],
        fabricProvider: FabricProvider? = nil,
        selectedFabricOption: FabricOption? = nil,
        fabricPrice: Double = 0
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
        self.fabricProvider = fabricProvider
        self.selectedFabricOption = selectedFabricOption
        self.fabricPrice = fabricPrice
    }
}

extension CartItem {
    static func fromCustomizationOrder(_ order: CustomizationOrder) -> CartItem? {
        guard let selectedItem = order.selectedItem else { return nil }
        
        let fabricPrice = (!order.isRepairService && order.fabricProvider == .tailor) ? 
            (order.selectedFabricOption?.additionalPrice ?? 0) : 0
        
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
            referenceImages: order.referenceImages,
            fabricProvider: order.isRepairService ? nil : order.fabricProvider,
            selectedFabricOption: order.selectedFabricOption,
            fabricPrice: fabricPrice
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
