import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var tailors: [Tailor] = []
    @Published var isLoading = true
    private let database = LocalDatabase.shared
    
    init(category: String? = nil) {
        loadTailors(category: category)
    }
    
    private func loadTailors(category: String?) {
        isLoading = true
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            
            if let category = category?.lowercased(), category != "semua penjahit" {
                self.tailors = self.database.getTailorsByCategory(category)
            } else {
                self.tailors = self.database.getTailors()
            }
            
            self.isLoading = false
        }
    }
}
