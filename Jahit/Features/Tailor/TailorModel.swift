//
//  TailorModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import Foundation

struct Tailor: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let profileImage: String
    let location: String
    let rating: Double
    let services: [TailorService]
    let reviews: [TailorReview]
    let description: String
    let locationDescription: String
}

struct TailorService: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let description: String
    let startingPrice: Double
    let images: [String]
    let items: [TailorServiceItem]
}

struct TailorServiceItem: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let image: String
    let price: Double
}

struct TailorReview: Identifiable, Hashable, Codable {
    let id: String
    let userName: String
    let rating: Int
    let comment: String
    let timeAgo: String
    let reviewImages: [String]
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
            profileImage: "alfa",
            location: "Bandung",
            rating: 4.8,
            services: [
                TailorService(
                    id: "s1", 
                    name: "Atasan", 
                    description: "Melayani jas, kemeja, jaket, cardigan, dan kerudung",
                    startingPrice: 80000, 
                    images: ["blazer"],
                    items: [
                        TailorServiceItem(id: "i1", name: "Jas", image: "jas", price: 150000),
                        TailorServiceItem(id: "i2", name: "Kemeja", image: "kemeja", price: 95000),
                        TailorServiceItem(id: "i3", name: "Jaket", image: "jaket", price: 200000),
                        TailorServiceItem(id: "i4", name: "Cardigan", image: "cardigan", price: 120000),
                        TailorServiceItem(id: "i5", name: "Kerudung", image: "kerudung", price: 80000)
                    ]
                ),
                TailorService(
                    id: "s2", 
                    name: "Bawahan", 
                    description: "Melayani celana bahan, denim, dan rok",
                    startingPrice: 85000, 
                    images: ["bawahan"],
                    items: [
                        TailorServiceItem(id: "i6", name: "Celana Bahan", image: "celana_bahan", price: 95000),
                        TailorServiceItem(id: "i7", name: "Celana Denim", image: "celana_denim", price: 100000),
                        TailorServiceItem(id: "i8", name: "Rok", image: "rok", price: 85000),
                    ]
                ),
                TailorService(
                    id: "s3", 
                    name: "Perbaikan", 
                    description: "Layanan perbaikan dan alterasi pakaian", 
                    startingPrice: 15000, 
                    images: ["perbaikan"],
                    items: [
                        TailorServiceItem(id: "i9", name: "Perbaikan Sobek", image: "robek", price: 35000),
                        TailorServiceItem(id: "i10", name: "Mengecilkan Ukuran", image: "alterasi", price: 45000),
                        TailorServiceItem(id: "i11", name: "Ganti Kancing", image: "kancing", price: 15000)
                    ]
                )
            ],
            reviews: [
                TailorReview(id: "r1", userName: "Budi", rating: 5, comment: "Bagus sekali!", timeAgo: "2 hari lalu", reviewImages: [])
            ],
            description: "Melayani jahit atasan, bawahan, dan perbaikan pakaian dengan kualitas terbaik.",
            locationDescription: "Jalan Siliwangi No. 123, Bandung"
        ),
        Tailor(
            id: "2",
            name: "Beta Tailor",
            profileImage: "beta",
            location: "Bandung",
            rating: 4.7,
            services: [
                TailorService(
                    id: "s4", 
                    name: "Atasan", 
                    description: "Melayani jas, kemeja, jaket, cardigan, dan kerudung",
                    startingPrice: 80000, 
                    images: ["blazer"],
                    items: [
                        TailorServiceItem(id: "i12", name: "Jas", image: "jas", price: 180000),
                        TailorServiceItem(id: "i13", name: "Kemeja", image: "kemeja", price: 95000),
                        TailorServiceItem(id: "i14", name: "Jaket", image: "jaket", price: 200000),
                        TailorServiceItem(id: "i15", name: "Cardigan", image: "cardigan", price: 120000),
                        TailorServiceItem(id: "i16", name: "Kerudung", image: "kerudung", price: 80000)
                    ]
                ),
                TailorService(
                    id: "s5", 
                    name: "Bawahan", 
                    description: "Melayani jahit bawahan dengan berbagai model",
                    startingPrice: 85000, 
                    images: ["bawahan"],
                    items: [
                        TailorServiceItem(id: "i17", name: "Celana Bahan", image: "celana_bahan", price: 95000),
                        TailorServiceItem(id: "i18", name: "Celana Denim", image: "celana_denim", price: 100000),
                        TailorServiceItem(id: "i19", name: "Rok", image: "rok", price: 85000)
                    ]
                )
            ],
            reviews: [
                TailorReview(id: "r2", userName: "Siti", rating: 4, comment: "Pelayanan baik!", timeAgo: "1 hari lalu", reviewImages: [])
            ],
            description: "Jasa jahit atasan dan bawahan sesuai kebutuhan Anda.",
            locationDescription: "Jalan Tubagus Ismail No. 456, Bandung"
        ),
        Tailor(
            id: "3",
            name: "Gamma Tailor",
            profileImage: "gamma",
            location: "Bandung",
            rating: 4.6,
            services: [
                TailorService(
                    id: "s6", 
                    name: "Terusan", 
                    description: "Spesialis dress",
                    startingPrice: 200000, 
                    images: ["blazer","blazer"],
                    items: [
                        TailorServiceItem(id: "i20", name: "Dress Pendek", image: "dress_pendek", price: 200000),
                        TailorServiceItem(id: "i21", name: "Dress Panjang", image: "dress_panjang", price: 250000),
                        TailorServiceItem(id: "i22", name: "Gamis", image: "gamis", price: 220000),
                        TailorServiceItem(id: "i23", name: "Jumpsuit", image: "jumpsuit", price: 230000)
                    ]
                )
            ],
            reviews: [
                TailorReview(id: "r3", userName: "Andi", rating: 5, comment: "Cepat dan rapi!", timeAgo: "5 hari lalu", reviewImages: [])
            ],
            description: "Jasa jahit terusan untuk berbagai acara.",
            locationDescription: "Jalan Dipatiukur No. 789, Bandung"
        ),
        Tailor(
            id: "4",
            name: "Delta Tailor",
            profileImage: "delta",
            location: "Bandung",
            rating: 4.5,
            services: [
                TailorService(
                    id: "s7",
                    name: "Atasan", 
                    description: "Melayani jas, kemeja, jaket, cardigan, dan kerudung",
                    startingPrice: 80000,
                    images: ["blazer"],
                    items: [
                        TailorServiceItem(id: "i24", name: "Jas", image: "jas", price: 150000),
                        TailorServiceItem(id: "i25", name: "Kemeja", image: "kemeja", price: 95000),
                        TailorServiceItem(id: "i26", name: "Jaket", image: "jaket", price: 200000),
                        TailorServiceItem(id: "i27", name: "Cardigan", image: "cardigan", price: 120000),
                        TailorServiceItem(id: "i28", name: "Kerudung", image: "kerudung", price: 80000)
                    ]
                ),
                TailorService(
                    id: "s8",
                    name: "Bawahan", 
                    description: "Melayani celana bahan, denim, dan rok",
                    startingPrice: 85000, 
                    images: ["bawahan"],
                    items: [
                        TailorServiceItem(id: "i29", name: "Celana Bahan", image: "celana_bahan", price: 95000),
                        TailorServiceItem(id: "i30", name: "Celana Denim", image: "celana_denim", price: 100000),
                        TailorServiceItem(id: "i31", name: "Rok", image: "rok", price: 85000)
                    ]
                )
            ],
            reviews: [
                TailorReview(id: "r4", userName: "Rina", rating: 4, comment: "Hasil memuaskan!", timeAgo: "3 hari lalu", reviewImages: [])
            ],
            description: "Jasa jahit atasan dan bawahan dengan harga terjangkau.",
            locationDescription: "Jalan Dago Asri No. 321, Bandung"
        )
    ]
}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
