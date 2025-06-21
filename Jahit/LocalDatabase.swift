import Foundation
class LocalDatabase: ObservableObject {    
    static let shared = LocalDatabase()
    
    @Published var tailors: [Tailor] = []
    
    private init() {
        self.tailors = Tailor.sampleTailors
    }
    
    func getTailors() -> [Tailor] {
        return tailors
    }
    
    func getTailor(by id: String) -> Tailor? {
        return tailors.first { $0.id == id }
    }
    
    func getTailorsByCategory(_ category: String) -> [Tailor] {
        return tailors.filter { tailor in
            tailor.services.contains { service in
                service.name.lowercased() == category.lowercased()
            }
        }
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
            userImage: nil
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
    
    func refreshData() {
        objectWillChange.send()
    }
}