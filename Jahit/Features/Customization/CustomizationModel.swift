//
//  File.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/06/25.
//

import Foundation

enum FabricProvider: String, CaseIterable, Codable {
    case tailor = "Bahan disediakan penjahit"
    case personal = "Bahan pribadi"
}

struct CustomizationOrder: Identifiable {
    let id = UUID()
    let tailorId: String
    let tailorName: String
    let category: String
    var selectedItem: TailorServiceItem?
    var description: String = ""
    var referenceImages: [String] = []
    var quantity: Int = 1
    var fabricProvider: FabricProvider = .tailor
    var selectedFabricOption: FabricOption?
    
    var isValid: Bool {
        guard selectedItem != nil else { return false }
        
        if isRepairService {
            return true
        }
        
        if fabricProvider == .tailor {
            return selectedFabricOption != nil
        }
        
        return true
    }
    
    var isRepairService: Bool {
        return category == "Perbaikan"
    }
    
    var totalPrice: Double {
        guard let item = selectedItem else { return 0 }
        let basePrice = item.price * Double(quantity)
        
        var fabricPrice: Double = 0
        if !isRepairService && fabricProvider == .tailor, let fabricOption = selectedFabricOption {
            fabricPrice = fabricOption.additionalPrice * Double(quantity)
        }
        
        return basePrice + fabricPrice
    }
}
