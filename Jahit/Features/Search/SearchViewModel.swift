import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var tailors: [Tailor] = []
    @Published var isLoading = true
    private let database = LocalDatabase.shared
    
    init(category: String? = nil) {
        loadTailors(category: category)
    }
    
    private func loadTailors(category: String?) {
        // Start with loading state
        isLoading = true
        tailors = []
        
        // Get data from database
        let tailorsData: [Tailor]
        if let category = category?.lowercased(), category != "semua penjahit" {
            tailorsData = database.getTailorsByCategory(category)
        } else {
            tailorsData = database.getTailors()
        }
        
        // Update UI on main thread after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.tailors = tailorsData
                self.isLoading = false
            }
        }
    }
}
