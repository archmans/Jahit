//
//  File.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/06/25.
//

import Foundation

struct CustomizationOrder: Identifiable {
    let id = UUID()
    let tailorId: String
    let tailorName: String
    let category: String
    var selectedItem: TailorServiceItem?
    var description: String = ""
    var referenceImages: [String] = []
    var quantity: Int = 1
    
    var isValid: Bool {
        return selectedItem != nil
    }
}
