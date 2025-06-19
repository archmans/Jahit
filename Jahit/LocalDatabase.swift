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
}