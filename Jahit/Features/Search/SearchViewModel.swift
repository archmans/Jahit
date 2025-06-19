import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var tailors: [Tailor] = []
    private let database = LocalDatabase.shared
    
    init(category: String? = nil) {
        if let category = category?.lowercased(), category != "semua penjahit" {
            self.tailors = database.getTailorsByCategory(category)
        } else {
            self.tailors = database.getTailors()
        }
    }
}
