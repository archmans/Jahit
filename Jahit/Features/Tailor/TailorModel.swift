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
    let items: [TailorServiceItem]
}

struct TailorServiceItem: Identifiable, Hashable {
    let id: String
    let name: String
    let image: String
    let price: Double
    let description: String?
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
                TailorService(
                    id: "s1", 
                    name: "Atasan", 
                    description: "Jasa jahit atasan berkualitas tinggi", 
                    startingPrice: 90000, 
                    images: ["blazer"],
                    items: [
                        TailorServiceItem(id: "i1", name: "Kemeja Formal", image: "atasan", price: 120000, description: "Kemeja formal untuk kerja"),
                        TailorServiceItem(id: "i2", name: "Blouse Casual", image: "atasan", price: 95000, description: "Blouse casual untuk sehari-hari"),
                        TailorServiceItem(id: "i3", name: "Blazer Premium", image: "blazer", price: 180000, description: "Blazer premium untuk acara formal")
                    ]
                ),
                TailorService(
                    id: "s2", 
                    name: "Bawahan", 
                    description: "Jasa jahit bawahan berkualitas tinggi", 
                    startingPrice: 75000, 
                    images: ["bawahan"],
                    items: [
                        TailorServiceItem(id: "i4", name: "Celana Panjang Formal", image: "bawahan", price: 110000, description: "Celana panjang untuk kerja"),
                        TailorServiceItem(id: "i5", name: "Rok A-Line", image: "bawahan", price: 85000, description: "Rok A-line untuk berbagai acara"),
                        TailorServiceItem(id: "i6", name: "Celana Jeans Custom", image: "bawahan", price: 130000, description: "Jeans custom sesuai ukuran")
                    ]
                ),
                TailorService(
                    id: "s3", 
                    name: "Perbaikan", 
                    description: "Layanan perbaikan dan alterasi pakaian", 
                    startingPrice: 25000, 
                    images: ["perbaikan"],
                    items: [
                        TailorServiceItem(id: "i10", name: "Perbaikan Sobek", image: "perbaikan", price: 35000, description: "Memperbaiki pakaian yang sobek"),
                        TailorServiceItem(id: "i11", name: "Mengecilkan Ukuran", image: "perbaikan", price: 45000, description: "Mengecilkan ukuran pakaian yang kebesaran"),
                        TailorServiceItem(id: "i12", name: "Ganti Kancing", image: "perbaikan", price: 15000, description: "Mengganti kancing yang lepas atau rusak")
                    ]
                )
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
                TailorService(
                    id: "s1", 
                    name: "Atasan", 
                    description: "Spesialis atasan modern dan trendy", 
                    startingPrice: 85000, 
                    images: ["blazer"],
                    items: [
                        TailorServiceItem(id: "i7", name: "Kemeja Kasual", image: "atasan", price: 105000, description: "Kemeja kasual untuk hangout"),
                        TailorServiceItem(id: "i8", name: "Crop Top Modern", image: "atasan", price: 75000, description: "Crop top trendy untuk anak muda"),
                        TailorServiceItem(id: "i9", name: "Blazer Casual", image: "blazer", price: 165000, description: "Blazer casual untuk acara semi-formal")
                    ]
                ),
                TailorService(
                    id: "s2", 
                    name: "Bawahan", 
                    description: "Ahli dalam membuat celana dan rok trendy", 
                    startingPrice: 70000, 
                    images: ["bawahan"],
                    items: [
                        TailorServiceItem(id: "i10", name: "Celana Chino", image: "bawahan", price: 95000, description: "Celana chino untuk casual formal"),
                        TailorServiceItem(id: "i11", name: "Rok Mini", image: "bawahan", price: 65000, description: "Rok mini untuk gaya casual"),
                        TailorServiceItem(id: "i12", name: "Celana Kulot", image: "bawahan", price: 85000, description: "Celana kulot untuk gaya bohemian")
                    ]
                )
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
                TailorService(
                    id: "s1", 
                    name: "Atasan", 
                    description: "Spesialis pakaian tradisional dan modern", 
                    startingPrice: 100000, 
                    images: ["blazer","blazer"],
                    items: [
                        TailorServiceItem(id: "i13", name: "Kebaya Modern", image: "atasan", price: 250000, description: "Kebaya modern untuk acara special"),
                        TailorServiceItem(id: "i14", name: "Kemeja Batik", image: "atasan", price: 145000, description: "Kemeja batik premium"),
                        TailorServiceItem(id: "i15", name: "Atasan Brokat", image: "atasan", price: 185000, description: "Atasan brokat untuk pesta")
                    ]
                ),
                TailorService(
                    id: "s2", 
                    name: "Bawahan", 
                    description: "Ahli rok dan celana dengan detail rumit", 
                    startingPrice: 80000, 
                    images: ["bawahan","bawahan"],
                    items: [
                        TailorServiceItem(id: "i16", name: "Rok Panjang Batik", image: "bawahan", price: 135000, description: "Rok panjang dengan motif batik"),
                        TailorServiceItem(id: "i17", name: "Celana Palazzo", image: "bawahan", price: 115000, description: "Celana palazzo untuk acara formal"),
                        TailorServiceItem(id: "i18", name: "Sarung Modern", image: "bawahan", price: 95000, description: "Sarung dengan desain modern")
                    ]
                )
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
                TailorService(
                    id: "s1", 
                    name: "Atasan", 
                    description: "Pakaian vintage dan retro style", 
                    startingPrice: 95000, 
                    images: ["blazer"],
                    items: [
                        TailorServiceItem(id: "i19", name: "Kemeja Vintage", image: "atasan", price: 125000, description: "Kemeja dengan gaya vintage klasik"),
                        TailorServiceItem(id: "i20", name: "Cardigan Rajut", image: "atasan", price: 155000, description: "Cardigan rajut hangat dan nyaman"),
                        TailorServiceItem(id: "i21", name: "Vest Classic", image: "blazer", price: 135000, description: "Vest klasik untuk gaya formal")
                    ]
                ),
                TailorService(
                    id: "s2", 
                    name: "Bawahan", 
                    description: "Celana dan rok dengan gaya klasik", 
                    startingPrice: 85000, 
                    images: ["bawahan"],
                    items: [
                        TailorServiceItem(id: "i22", name: "Celana High Waist", image: "bawahan", price: 120000, description: "Celana high waist vintage style"),
                        TailorServiceItem(id: "i23", name: "Rok Circle", image: "bawahan", price: 105000, description: "Rok circle untuk gaya retro"),
                        TailorServiceItem(id: "i24", name: "Celana Lebar Classic", image: "bawahan", price: 115000, description: "Celana lebar dengan potongan klasik")
                    ]
                )
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
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
