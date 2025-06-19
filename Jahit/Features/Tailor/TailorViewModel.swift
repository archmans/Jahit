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
    @Published var serviceImageIndices: [String: Int] = [:]
    @Published var isLoading = false
    
    init(tailor: Tailor = Tailor.sampleTailors.first!) {
        self.tailor = tailor
        // Initialize image indices for all services
        for service in tailor.services {
            serviceImageIndices[service.id] = 0
        }
    }
    
    var formattedRating: String {
        return "\(tailor.rating)/\(tailor.maxRating)"
    }
    
    var currentService: TailorService? {
        return tailor.services.first
    }
    
    func formattedStartingPrice(for service: TailorService) -> String {
        return NumberFormatter.priceFormatter.string(from: NSNumber(value: service.startingPrice)) ?? "Rp0"
    }
    
    func getCurrentImageIndex(for serviceId: String) -> Int {
        return serviceImageIndices[serviceId] ?? 0
    }
    
    func setCurrentImageIndex(_ index: Int, for serviceId: String) {
        serviceImageIndices[serviceId] = index
    }
    
    func selectTab(_ tab: TailorTab) {
        selectedTab = tab
    }
    
    func nextImage(for serviceId: String) {
        guard let service = tailor.services.first(where: { $0.id == serviceId }) else { return }
        let currentIndex = serviceImageIndices[serviceId] ?? 0
        serviceImageIndices[serviceId] = (currentIndex + 1) % service.images.count
    }
    
    func previousImage(for serviceId: String) {
        guard let service = tailor.services.first(where: { $0.id == serviceId }) else { return }
        let currentIndex = serviceImageIndices[serviceId] ?? 0
        serviceImageIndices[serviceId] = currentIndex > 0 ? currentIndex - 1 : service.images.count - 1
    }
    
    func goToImage(at index: Int, for serviceId: String) {
        guard let service = tailor.services.first(where: { $0.id == serviceId }), 
              index < service.images.count else { return }
        serviceImageIndices[serviceId] = index
    }
    
    func contactViaWhatsApp() {
        print("Contacting \(tailor.name) via WhatsApp")
    }
    
    func goBack() {
        print("Going back...")
    }
}
