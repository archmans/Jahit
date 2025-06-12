//
//  FilterModalViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 12/06/25.
//

import SwiftUI

class FilterViewModel: ObservableObject {
    @Published var filterOptions = FilterOptions()
    @Published var isShowingFilter = false
    
    func togglePriceRange(_ range: PriceRange) {
        if filterOptions.priceRanges.contains(range) {
            filterOptions.priceRanges.remove(range)
        } else {
            filterOptions.priceRanges.insert(range)
        }
    }
    
    func toggleServiceType(_ type: ServiceType) {
        if filterOptions.serviceTypes.contains(type) {
            filterOptions.serviceTypes.remove(type)
        } else {
            filterOptions.serviceTypes.insert(type)
        }
    }
    
    func applyFilters() {
        // Apply filter logic here
        isShowingFilter = false
    }
    
    func resetFilters() {
        filterOptions = FilterOptions()
    }
}
