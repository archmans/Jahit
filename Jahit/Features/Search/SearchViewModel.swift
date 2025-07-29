import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var tailors: [Tailor] = []
    @Published var isLoading = false
    private let database = LocalDatabase.shared
    
    init() {}
    
    private func loadTailors(category: String?) {
        isLoading = true
        
        let tailorsData: [Tailor]
        if let category = category?.lowercased(), category != "semua penjahit" {
            tailorsData = database.getTailorsByCategory(category)
        } else {
            tailorsData = database.getTailors()
        }
        
        self.tailors = tailorsData
        self.isLoading = false
    }
    
    func setCategory(_ category: String) {
        loadTailors(category: category)
    }
}
