//
//  TailorModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import Foundation

struct Tailor {
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

struct TailorService {
    let id: String
    let name: String
    let description: String
    let startingPrice: Double
    let images: [String]
}

struct Review {
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
    static let sampleTailor = Tailor(
        id: "1",
        name: "Alfa Tailor",
        profileImage: "penjahit",
        location: "Jalan Sekoloa",
        rating: 4.9,
        maxRating: 5,
        services: [
            TailorService(
                id: "1",
                name: "Atasan",
                description: "Baju Kantor, Baju Kerja, Kemeja, Blazer, Sweater, Knitting, dll",
                startingPrice: 45000,
                images: ["blazer", "blazer", "blazer"]
            )
        ],
        reviews: [
            Review(
                id: "1",
                userName: "User",
                rating: 5,
                comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                timeAgo: "3 hari yang lalu",
                userImage: "blazer"
            ),
            Review(
                id: "2",
                userName: "User",
                rating: 5,
                comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                timeAgo: "3 hari yang lalu",
                userImage: "blazer"
            )
        ],
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo.",
        locationDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
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
