import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var tailors: [Tailor] = []
    @Published var isLoading = false
    private let database = LocalDatabase.shared
    
    init() {
        // Don't load tailors in init, wait for setCategory to be called
    }
    
    private func loadTailors(category: String?) {
        // Start with loading state
        isLoading = true
        
        // Perform data loading synchronously since LocalDatabase is already in memory
        let tailorsData: [Tailor]
        if let category = category?.lowercased(), category != "semua penjahit" {
            tailorsData = database.getTailorsByCategory(category)
        } else {
            tailorsData = database.getTailors()
        }
        
        // Update UI synchronously for faster loading
        self.tailors = tailorsData
        self.isLoading = false
    }
    
    func setCategory(_ category: String) {
        loadTailors(category: category)
    }
}
