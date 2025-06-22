import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var tailors: [Tailor] = []
    @Published var isLoading = false
    private let database = LocalDatabase.shared
    
    init(category: String? = nil) {
        loadTailors(category: category)
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
        
        print("SearchViewModel: Loaded \(tailorsData.count) tailors for category: \(category ?? "all")")
    }
}
