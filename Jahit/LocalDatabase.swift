import Foundation
class LocalDatabase: ObservableObject {    
    static let shared = LocalDatabase()
    
    @Published var tailors: [Tailor] = []
    private let userDefaults = UserDefaults.standard
    private let tailorsKey = "savedTailors"
    
    private init() {
        loadTailorsFromStorage()
    }
    
    private func loadTailorsFromStorage() {
        if let tailorsData = userDefaults.data(forKey: tailorsKey),
           let savedTailors = try? JSONDecoder().decode([Tailor].self, from: tailorsData) {
            self.tailors = savedTailors
        } else {
            // First time launch - use sample data
            self.tailors = Tailor.sampleTailors
            saveTailorsToStorage()
        }
    }
    
    private func saveTailorsToStorage() {
        if let tailorsData = try? JSONEncoder().encode(tailors) {
            userDefaults.set(tailorsData, forKey: tailorsKey)
        }
    }
    
    func getTailors() -> [Tailor] {
        return tailors
    }
    
    func getTailor(by id: String) -> Tailor? {
        return tailors.first { $0.id == id }
    }
    
    func getTailorsByCategory(_ category: String) -> [Tailor] {
        print("LocalDatabase: Filtering tailors by category: '\(category)'")
        
        let filtered = tailors.filter { tailor in
            let hasMatchingService = tailor.services.contains { service in
                service.name.lowercased() == category.lowercased()
            }
            return hasMatchingService
        }
        
        print("LocalDatabase: Found \(filtered.count) tailors for category '\(category)'")
        print("LocalDatabase: Available services in all tailors: \(tailors.flatMap { $0.services.map { $0.name } }.unique())")
        
        return filtered
    }
    
    func addReviewToTailor(tailorId: String, review: Review) {
        guard let index = tailors.firstIndex(where: { $0.id == tailorId }) else {
            print("Tailor not found: \(tailorId)")
            return
        }
        
        // Check if review already exists to avoid duplicates
        let existingReviews = tailors[index].reviews
        if existingReviews.contains(where: { $0.id == review.id }) {
            print("Review already exists for tailor \(tailorId)")
            return
        }
        
        // Convert Review to TailorReview
        let tailorReview = TailorReview(
            id: review.id,
            userName: review.userName,
            rating: review.rating,
            comment: review.comment,
            timeAgo: formatTimeAgo(from: review.createdDate),
            reviewImages: review.reviewImages
        )
        
        // Add review to tailor
        let updatedTailor = tailors[index]
        var updatedReviews = updatedTailor.reviews
        updatedReviews.append(tailorReview)
        
        // Update tailor with new reviews and recalculated rating
        let newRating = calculateAverageRating(reviews: updatedReviews)
        
        tailors[index] = Tailor(
            id: updatedTailor.id,
            name: updatedTailor.name,
            profileImage: updatedTailor.profileImage,
            location: updatedTailor.location,
            rating: newRating,
            maxRating: updatedTailor.maxRating,
            services: updatedTailor.services,
            reviews: updatedReviews,
            description: updatedTailor.description,
            locationDescription: updatedTailor.locationDescription
        )
        
        print("Added review to tailor \(tailorId). New rating: \(newRating)")
        print("Tailor now has \(updatedReviews.count) reviews")
        
        // Save to persistent storage
        saveTailorsToStorage()
        
        // Trigger UI update by explicitly updating the published property
        DispatchQueue.main.async {
            // Force the @Published property to trigger by reassigning the array
            let updatedTailors = self.tailors
            self.tailors = updatedTailors
            self.objectWillChange.send()
        }
    }
    
    private func calculateAverageRating(reviews: [TailorReview]) -> Double {
        guard !reviews.isEmpty else { return 0.0 }
        let totalRating = reviews.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(reviews.count)
    }
    
    private func formatTimeAgo(from date: Date) -> String {
        let timeInterval = Date().timeIntervalSince(date)
        let days = Int(timeInterval / 86400) // 86400 seconds in a day
        
        if days == 0 {
            return "Hari ini"
        } else if days == 1 {
            return "1 hari lalu"
        } else {
            return "\(days) hari lalu"
        }
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}