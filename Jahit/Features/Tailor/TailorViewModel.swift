//
//  TailorViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI
import Combine

class TailorViewModel: ObservableObject {
    @Published var tailor: Tailor
    @Published var selectedTab: TailorTab = .services
    @Published var currentImageIndex: Int = 0
    @Published var isLoading = false
    
    init(tailor: Tailor = Tailor.sampleTailor) {
        self.tailor = tailor
    }
    
    var formattedRating: String {
        return "\(tailor.rating)/\(tailor.maxRating)"
    }
    
    var currentService: TailorService? {
        return tailor.services.first
    }
    
    var formattedStartingPrice: String {
        guard let service = currentService else { return "Rp0" }
        return NumberFormatter.priceFormatter.string(from: NSNumber(value: service.startingPrice)) ?? "Rp0"
    }
    
    func selectTab(_ tab: TailorTab) {
        selectedTab = tab
    }
    
    func nextImage() {
        guard let service = currentService else { return }
        currentImageIndex = (currentImageIndex + 1) % service.images.count
    }
    
    func previousImage() {
        guard let service = currentService else { return }
        currentImageIndex = currentImageIndex > 0 ? currentImageIndex - 1 : service.images.count - 1
    }
    
    func goToImage(at index: Int) {
        guard let service = currentService, index < service.images.count else { return }
        currentImageIndex = index
    }
    
    func contactViaWhatsApp() {
        print("Contacting \(tailor.name) via WhatsApp")
    }
    
    func goBack() {
        print("Going back...")
    }
}
