//
//  SearchKeywordViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 06/05/25.
//

import SwiftUI
import Combine

class SearchKeywordViewModel: ObservableObject {
    @Published var searchResults: [SearchResult] = []
    @Published var isLoading = false
    
    private var searchTask: Task<Void, Never>?
    
    func search(query: String) {
        searchTask?.cancel()
        
        guard !query.isEmpty else {
            clearResults()
            return
        }
        
        isLoading = true
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            await MainActor.run {
                guard !Task.isCancelled else { return }
                
                let results = performSearch(query: query.lowercased())
                self.searchResults = results
                self.isLoading = false
            }
        }
    }
    
    func clearResults() {
        searchTask?.cancel()
        searchResults = []
        isLoading = false
    }
    
    private func performSearch(query: String) -> [SearchResult] {
        var results: [SearchResult] = []
        
        for tailor in Tailor.sampleTailors {
            if tailor.name.lowercased().contains(query) {
                results.append(.tailor(tailor))
            }
            
            for service in tailor.services {
                for item in service.items {
                    if item.name.lowercased().contains(query) || 
                        service.name.lowercased().contains(query) {
                        let product = ProductSearchResult(
                            id: item.id,
                            name: item.name,
                            image: item.image,
                            price: item.price,
                            tailorId: tailor.id,
                            tailorName: tailor.name,
                            category: service.name
                        )
                        results.append(.product(product))
                    }
                }
            }
        }
        
        var uniqueResults: [SearchResult] = []
        var addedTailorIds: Set<String> = []
        
        for result in results {
            if case .product = result {
                uniqueResults.append(result)
            }
        }
        
        for result in results {
            if case .tailor(let tailor) = result {
                let hasProductFromTailor = uniqueResults.contains { searchResult in
                    if case .product(let product) = searchResult {
                        return product.tailorId == tailor.id
                    }
                    return false
                }
                
                if !hasProductFromTailor && !addedTailorIds.contains(tailor.id) {
                    uniqueResults.append(result)
                    addedTailorIds.insert(tailor.id)
                }
            }
        }
        
        return uniqueResults
    }
}

enum SearchResult: Identifiable {
    case product(ProductSearchResult)
    case tailor(Tailor)
    
    var id: String {
        switch self {
        case .product(let product):
            return "product_\(product.id)"
        case .tailor(let tailor):
            return "tailor_\(tailor.id)"
        }
    }
}

struct ProductSearchResult: Identifiable {
    let id: String
    let name: String
    let image: String
    let price: Double
    let tailorId: String
    let tailorName: String
    let category: String
}
