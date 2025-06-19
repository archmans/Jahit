//
//  TailorModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import Foundation

struct Tailor: Identifiable, Hashable {
    let id: String
    let name: String
    let profileImage: String
    let location: String
    let rating: Double
    let maxRating: Int
    let services: [TailorService]
    let reviews: [Review]
    let description: String
    let locationDescription: String
}

struct TailorService: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let startingPrice: Double
    let images: [String]
}

struct Review: Identifiable, Hashable {
    let id: String
    let userName: String
    let rating: Int
    let comment: String
    let timeAgo: String
    let userImage: String?
}

enum TailorTab: String, CaseIterable {
    case services = "Jasa Jahit"
    case reviews = "Ulasan"
    case about = "Tentang"
}

extension Tailor {
    static let sampleTailors: [Tailor] = [
        Tailor(
            id: "1",
            name: "Alfa Tailor",
            profileImage: "penjahit",
            location: "Bandung",
            rating: 4.8,
            maxRating: 5,
            services: [
                TailorService(id: "s1", name: "Atasan", description: "Jasa jahit atasan", startingPrice: 90000, images: ["blazer"]),
                TailorService(id: "s2", name: "Bawahan", description: "Jasa jahit bawahan", startingPrice: 75000, images: ["blazer"])
            ],
            reviews: [
                Review(id: "r1", userName: "Budi", rating: 5, comment: "Bagus sekali!", timeAgo: "2 hari lalu", userImage: nil)
            ],
            description: "Penjahit profesional.",
            locationDescription: "Dekat ITB"
        ),
        Tailor(
            id: "2",
            name: "Beta Tailor",
            profileImage: "penjahit",
            location: "Jakarta",
            rating: 4.7,
            maxRating: 5,
            services: [
                TailorService(id: "s1", name: "Atasan", description: "Jasa jahit atasan", startingPrice: 90000, images: ["blazer"]),
                TailorService(id: "s2", name: "Bawahan", description: "Jasa jahit bawahan", startingPrice: 75000, images: ["blazer"])
            ],
            reviews: [
                Review(id: "r2", userName: "Siti", rating: 4, comment: "Pelayanan baik!", timeAgo: "1 hari lalu", userImage: nil)
            ],
            description: "Penjahit profesional.",
            locationDescription: "Dekat UI"
        ),
        Tailor(
            id: "3",
            name: "Gamma Tailor",
            profileImage: "penjahit",
            location: "Surabaya",
            rating: 4.6,
            maxRating: 5,
            services: [
                TailorService(id: "s1", name: "Atasan", description: "Jasa jahit atasan", startingPrice: 90000, images: ["blazer","blazer"]),
                TailorService(id: "s2", name: "Bawahan", description: "Jasa jahit bawahan", startingPrice: 75000, images: ["blazer","blazer"])
            ],
            reviews: [
                Review(id: "r3", userName: "Andi", rating: 5, comment: "Cepat dan rapi!", timeAgo: "5 hari lalu", userImage: nil)
            ],
            description: "Penjahit profesional.",
            locationDescription: "Dekat ITS"
        ),
        Tailor(
            id: "4",
            name: "Delta Tailor",
            profileImage: "penjahit",
            location: "Yogyakarta",
            rating: 4.5,
            maxRating: 5,
            services: [
                TailorService(id: "s1", name: "Atasan", description: "Jasa jahit atasan", startingPrice: 90000, images: ["blazer"]),
                TailorService(id: "s2", name: "Bawahan", description: "Jasa jahit bawahan", startingPrice: 75000, images: ["blazer"])
            ],
            reviews: [
                Review(id: "r4", userName: "Rina", rating: 4, comment: "Hasil memuaskan!", timeAgo: "3 hari lalu", userImage: nil)
            ],
            description: "Penjahit profesional.",
            locationDescription: "Dekat UGM"
        )
    ]
}

extension NumberFormatter {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
