// import Foundation

// struct TailorCart: Identifiable {
//     let id: String
//     let tailor: Tailor
//     var items: [CartItem]
//     var isSelectAll: Bool = false
// }

// struct CartItem: Identifiable, Hashable {
//     let id = UUID()
//     let tailorId: String
//     let tailorName: String
//     let category: String
//     let itemName: String
//     let image: String
//     var quantity: Int
//     let basePrice: Double
//     var isSelected: Bool = false
    
//     var totalPrice: Double {
//         return Double(quantity) * basePrice
//     }
// }

// extension CartItem {
//     static let sampleItems = [
//         CartItem(tailorId: "1", tailorName: "Alfa Tailor", category: "Atasan", itemName: "Blazer", image: "blazer", quantity: 2, basePrice: 90000),
//         CartItem(tailorId: "1", tailorName: "Alfa Tailor", category: "Bawahan", itemName: "Celana", image: "blazer", quantity: 1, basePrice: 75000),
//         CartItem(tailorId: "2", tailorName: "Beta Tailor", category: "Atasan", itemName: "Kemeja", image: "blazer", quantity: 1, basePrice: 65000),
//         CartItem(tailorId: "2", tailorName: "Beta Tailor", category: "Bawahan", itemName: "Celana Pendek", image: "blazer", quantity: 3, basePrice: 60000)
//     ]
    
// //    static let sampleItems: [CartItem] = []
// }
