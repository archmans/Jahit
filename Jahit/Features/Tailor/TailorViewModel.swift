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
    
    private let localDatabase = LocalDatabase.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(tailor: Tailor = Tailor.sampleTailors.first!) {
        self.tailor = tailor
        for service in tailor.services {
            serviceImageIndices[service.id] = 0
        }
        
        localDatabase.$tailors
            .sink { [weak self] updatedTailors in
                if let updatedTailor = updatedTailors.first(where: { $0.id == self?.tailor.id }) {
                    DispatchQueue.main.async {
                        self?.tailor = updatedTailor
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    var formattedRating: String {
        let roundedRating = (tailor.rating * 10).rounded() / 10
        return String(format: "%.1f", roundedRating) + "/5"
    }
    
    var currentService: TailorService? {
        return tailor.services.first
    }
    
    func formattedStartingPrice(for service: TailorService) -> String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: service.startingPrice)) ?? "Rp0"
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
    }
    
    func goBack() {
    }
}
