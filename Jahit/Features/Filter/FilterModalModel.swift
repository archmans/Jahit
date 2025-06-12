//
//  FilterModalModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 12/06/25.
//

struct FilterOptions {
    var sortBy: SortOption = .nearest
    var priceRanges: Set<PriceRange> = []
    var serviceTypes: Set<ServiceType> = []
}

enum SortOption: String, CaseIterable {
    case nearest = "Terdekat"
    case rating = "Rating"
    case price = "Harga"
    
    var displayName: String {
        return self.rawValue
    }
}

enum PriceRange: String, CaseIterable {
    case under30k = "Di bawah Rp30.000"
    case range30to60k = "Rp30.000 sampai Rp60.000"
    case range60to100k = "Rp60.000 sampai Rp100.000"
    case above100k = "Di atas Rp100.000"
    
    var displayName: String {
        return self.rawValue
    }
    
    var priceSymbol: String {
        switch self {
        case .under30k: return "$$$"
        case .range30to60k: return "$$$"
        case .range60to100k: return "$$$"
        case .above100k: return "$$$$"
        }
    }
}

enum ServiceType: String, CaseIterable {
    case atasan = "Atasan"
    case bawahan = "Bawahan"
    case terusan = "Terusan"
    case alterasi = "Alterasi"
    
    var displayName: String {
        return self.rawValue
    }
}
