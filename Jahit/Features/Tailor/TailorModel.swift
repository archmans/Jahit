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
    let availableFabrics: [FabricOption]
}

struct FabricOption: Identifiable, Hashable, Codable {
    let id: String
    let type: String
    let description: String
    let additionalPrice: Double
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
                    images: ["porto_jas", "porto_kemeja", "porto_cardigan"],
                    items: [
                        TailorServiceItem(
                            id: "i1", 
                            name: "Jas", 
                            image: "jas", 
                            price: 150000,
                            availableFabrics: [
                                FabricOption(id: "f1", type: "Wol", description: "Bahan wol premium untuk jas formal", additionalPrice: 50000),
                                FabricOption(id: "f2", type: "Polyester", description: "Bahan sintetis tahan lama", additionalPrice: 30000),
                                FabricOption(id: "f3", type: "Linen", description: "Bahan alami yang sejuk", additionalPrice: 40000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i2", 
                            name: "Kemeja", 
                            image: "kemeja", 
                            price: 95000,
                            availableFabrics: [
                                FabricOption(id: "f4", type: "Katun", description: "Bahan katun yang nyaman", additionalPrice: 25000),
                                FabricOption(id: "f5", type: "Polyester", description: "Bahan anti kusut", additionalPrice: 30000),
                                FabricOption(id: "f6", type: "Linen", description: "Bahan premium yang adem", additionalPrice: 40000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i3", 
                            name: "Jaket", 
                            image: "jaket", 
                            price: 200000,
                            availableFabrics: [
                                FabricOption(id: "f7", type: "Denim", description: "Bahan denim tebal dan kuat", additionalPrice: 35000),
                                FabricOption(id: "f8", type: "Polyester", description: "Bahan tahan air", additionalPrice: 30000),
                                FabricOption(id: "f9", type: "Wol", description: "Bahan hangat untuk musim dingin", additionalPrice: 50000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i4", 
                            name: "Cardigan", 
                            image: "cardigan", 
                            price: 120000,
                            availableFabrics: [
                                FabricOption(id: "f10", type: "Katun", description: "Bahan katun lembut", additionalPrice: 25000),
                                FabricOption(id: "f11", type: "Wol", description: "Bahan wol yang hangat", additionalPrice: 50000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i5", 
                            name: "Kerudung", 
                            image: "kerudung", 
                            price: 80000,
                            availableFabrics: [
                                FabricOption(id: "f12", type: "Sutra", description: "Bahan sutra yang elegan", additionalPrice: 60000),
                                FabricOption(id: "f13", type: "Polyester", description: "Bahan praktis dan mudah dirawat", additionalPrice: 30000)
                            ]
                        )
                    ]
                ),
                TailorService(
                    id: "s2", 
                    name: "Bawahan", 
                    description: "Melayani celana bahan, denim, dan rok",
                    startingPrice: 85000, 
                    images: ["porto_bahan", "porto_denim", "porto_rok"],
                    items: [
                        TailorServiceItem(
                            id: "i6", 
                            name: "Celana Bahan", 
                            image: "celana_bahan", 
                            price: 95000,
                            availableFabrics: [
                                FabricOption(id: "f14", type: "Wol", description: "Bahan wol untuk celana formal", additionalPrice: 50000),
                                FabricOption(id: "f15", type: "Polyester", description: "Bahan anti kusut", additionalPrice: 30000),
                                FabricOption(id: "f16", type: "Katun", description: "Bahan katun yang nyaman", additionalPrice: 25000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i7", 
                            name: "Celana Denim", 
                            image: "celana_denim", 
                            price: 100000,
                            availableFabrics: [
                                FabricOption(id: "f17", type: "Denim", description: "Bahan denim original", additionalPrice: 35000),
                                FabricOption(id: "f18", type: "Denim", description: "Bahan denim stretch", additionalPrice: 40000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i8", 
                            name: "Rok", 
                            image: "rok", 
                            price: 85000,
                            availableFabrics: [
                                FabricOption(id: "f19", type: "Katun", description: "Bahan katun yang adem", additionalPrice: 25000),
                                FabricOption(id: "f20", type: "Polyester", description: "Bahan yang mudah dirawat", additionalPrice: 30000),
                                FabricOption(id: "f21", type: "Linen", description: "Bahan linen untuk rok kasual", additionalPrice: 40000)
                            ]
                        ),
                    ]
                ),
                TailorService(
                    id: "s3", 
                    name: "Perbaikan", 
                    description: "Layanan perbaikan dan alterasi pakaian", 
                    startingPrice: 15000, 
                    images: ["porto_robek", "porto_kancing"],
                    items: [
                        TailorServiceItem(
                            id: "i9", 
                            name: "Perbaikan Sobek", 
                            image: "robek", 
                            price: 35000,
                            availableFabrics: [
                                FabricOption(id: "f22", type: "Sesuai Asli", description: "Menggunakan bahan sesuai pakaian asli", additionalPrice: 0)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i10", 
                            name: "Mengecilkan Ukuran", 
                            image: "alterasi", 
                            price: 45000,
                            availableFabrics: [
                                FabricOption(id: "f23", type: "Sesuai Asli", description: "Tidak memerlukan bahan tambahan", additionalPrice: 0)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i11", 
                            name: "Ganti Kancing", 
                            image: "kancing", 
                            price: 15000,
                            availableFabrics: [
                                FabricOption(id: "f24", type: "Kancing Plastik", description: "Kancing plastik standar", additionalPrice: 5000),
                                FabricOption(id: "f25", type: "Kancing Kayu", description: "Kancing kayu premium", additionalPrice: 10000),
                                FabricOption(id: "f26", type: "Kancing Logam", description: "Kancing logam berkualitas", additionalPrice: 15000)
                            ]
                        )
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
                    images: ["porto_jas", "porto_kemeja", "porto_cardigan"],
                    items: [
                        TailorServiceItem(
                            id: "i12", 
                            name: "Jas", 
                            image: "jas", 
                            price: 180000,
                            availableFabrics: [
                                FabricOption(id: "f27", type: "Wol", description: "Bahan wol premium", additionalPrice: 50000),
                                FabricOption(id: "f28", type: "Sutra", description: "Bahan sutra mewah", additionalPrice: 60000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i13", 
                            name: "Kemeja", 
                            image: "kemeja", 
                            price: 95000,
                            availableFabrics: [
                                FabricOption(id: "f29", type: "Katun", description: "Bahan katun berkualitas", additionalPrice: 25000),
                                FabricOption(id: "f30", type: "Linen", description: "Bahan linen premium", additionalPrice: 40000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i14", 
                            name: "Jaket", 
                            image: "jaket", 
                            price: 200000,
                            availableFabrics: [
                                FabricOption(id: "f31", type: "Denim", description: "Bahan denim tebal", additionalPrice: 35000),
                                FabricOption(id: "f32", type: "Wol", description: "Bahan wol hangat", additionalPrice: 50000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i15", 
                            name: "Cardigan", 
                            image: "cardigan", 
                            price: 120000,
                            availableFabrics: [
                                FabricOption(id: "f33", type: "Katun", description: "Bahan katun lembut", additionalPrice: 25000),
                                FabricOption(id: "f34", type: "Wol", description: "Bahan wol berkualitas", additionalPrice: 50000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i16", 
                            name: "Kerudung", 
                            image: "kerudung", 
                            price: 80000,
                            availableFabrics: [
                                FabricOption(id: "f35", type: "Sutra", description: "Bahan sutra halus", additionalPrice: 60000),
                                FabricOption(id: "f36", type: "Polyester", description: "Bahan praktis", additionalPrice: 30000)
                            ]
                        )
                    ]
                ),
                TailorService(
                    id: "s5", 
                    name: "Bawahan", 
                    description: "Melayani jahit bawahan dengan berbagai model",
                    startingPrice: 85000, 
                    images: ["porto_bahan", "porto_denim", "porto_rok"],
                    items: [
                        TailorServiceItem(
                            id: "i17", 
                            name: "Celana Bahan", 
                            image: "celana_bahan", 
                            price: 95000,
                            availableFabrics: [
                                FabricOption(id: "f37", type: "Wol", description: "Bahan wol untuk celana formal", additionalPrice: 50000),
                                FabricOption(id: "f38", type: "Polyester", description: "Bahan anti kusut", additionalPrice: 30000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i18", 
                            name: "Celana Denim", 
                            image: "celana_denim", 
                            price: 100000,
                            availableFabrics: [
                                FabricOption(id: "f39", type: "Denim", description: "Bahan denim berkualitas", additionalPrice: 35000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i19", 
                            name: "Rok", 
                            image: "rok", 
                            price: 85000,
                            availableFabrics: [
                                FabricOption(id: "f40", type: "Katun", description: "Bahan katun nyaman", additionalPrice: 25000),
                                FabricOption(id: "f41", type: "Linen", description: "Bahan linen elegan", additionalPrice: 40000)
                            ]
                        )
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
                    images: ["porto_gaun", "porto_pendek"],
                    items: [
                        TailorServiceItem(
                            id: "i20", 
                            name: "Dress Pendek", 
                            image: "dress_pendek", 
                            price: 200000,
                            availableFabrics: [
                                FabricOption(id: "f42", type: "Katun", description: "Bahan katun untuk dress kasual", additionalPrice: 25000),
                                FabricOption(id: "f43", type: "Sutra", description: "Bahan sutra untuk dress formal", additionalPrice: 60000),
                                FabricOption(id: "f44", type: "Linen", description: "Bahan linen untuk dress santai", additionalPrice: 40000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i21", 
                            name: "Dress Panjang", 
                            image: "dress_panjang", 
                            price: 250000,
                            availableFabrics: [
                                FabricOption(id: "f45", type: "Sutra", description: "Bahan sutra mewah", additionalPrice: 60000),
                                FabricOption(id: "f46", type: "Polyester", description: "Bahan polyester elegan", additionalPrice: 30000),
                                FabricOption(id: "f47", type: "Linen", description: "Bahan linen premium", additionalPrice: 40000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i22", 
                            name: "Gamis", 
                            image: "gamis", 
                            price: 220000,
                            availableFabrics: [
                                FabricOption(id: "f48", type: "Katun", description: "Bahan katun untuk gamis sehari-hari", additionalPrice: 25000),
                                FabricOption(id: "f49", type: "Sutra", description: "Bahan sutra untuk gamis pesta", additionalPrice: 60000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i23", 
                            name: "Jumpsuit", 
                            image: "jumpsuit", 
                            price: 230000,
                            availableFabrics: [
                                FabricOption(id: "f50", type: "Denim", description: "Bahan denim untuk jumpsuit kasual", additionalPrice: 35000),
                                FabricOption(id: "f51", type: "Polyester", description: "Bahan polyester untuk jumpsuit formal", additionalPrice: 30000)
                            ]
                        )
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
                    images: ["porto_jas", "porto_kemeja", "porto_cardigan"],
                    items: [
                        TailorServiceItem(
                            id: "i24", 
                            name: "Jas", 
                            image: "jas", 
                            price: 150000,
                            availableFabrics: [
                                FabricOption(id: "f52", type: "Wol", description: "Bahan wol berkualitas", additionalPrice: 50000),
                                FabricOption(id: "f53", type: "Polyester", description: "Bahan polyester ekonomis", additionalPrice: 30000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i25", 
                            name: "Kemeja", 
                            image: "kemeja", 
                            price: 95000,
                            availableFabrics: [
                                FabricOption(id: "f54", type: "Katun", description: "Bahan katun standar", additionalPrice: 25000),
                                FabricOption(id: "f55", type: "Polyester", description: "Bahan anti kusut", additionalPrice: 30000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i26", 
                            name: "Jaket", 
                            image: "jaket", 
                            price: 200000,
                            availableFabrics: [
                                FabricOption(id: "f56", type: "Denim", description: "Bahan denim standar", additionalPrice: 35000),
                                FabricOption(id: "f57", type: "Polyester", description: "Bahan polyester tahan air", additionalPrice: 30000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i27", 
                            name: "Cardigan", 
                            image: "cardigan", 
                            price: 120000,
                            availableFabrics: [
                                FabricOption(id: "f58", type: "Katun", description: "Bahan katun lembut", additionalPrice: 25000),
                                FabricOption(id: "f59", type: "Wol", description: "Bahan wol hangat", additionalPrice: 50000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i28", 
                            name: "Kerudung", 
                            image: "kerudung", 
                            price: 80000,
                            availableFabrics: [
                                FabricOption(id: "f60", type: "Polyester", description: "Bahan polyester praktis", additionalPrice: 30000),
                                FabricOption(id: "f61", type: "Sutra", description: "Bahan sutra premium", additionalPrice: 60000)
                            ]
                        )
                    ]
                ),
                TailorService(
                    id: "s8",
                    name: "Bawahan", 
                    description: "Melayani celana bahan, denim, dan rok",
                    startingPrice: 85000, 
                    images: ["porto_bahan", "porto_denim", "porto_rok"],
                    items: [
                        TailorServiceItem(
                            id: "i29", 
                            name: "Celana Bahan", 
                            image: "celana_bahan", 
                            price: 95000,
                            availableFabrics: [
                                FabricOption(id: "f62", type: "Wol", description: "Bahan wol untuk celana formal", additionalPrice: 50000),
                                FabricOption(id: "f63", type: "Polyester", description: "Bahan polyester ekonomis", additionalPrice: 30000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i30", 
                            name: "Celana Denim", 
                            image: "celana_denim", 
                            price: 100000,
                            availableFabrics: [
                                FabricOption(id: "f64", type: "Denim", description: "Bahan denim standar", additionalPrice: 35000)
                            ]
                        ),
                        TailorServiceItem(
                            id: "i31", 
                            name: "Rok", 
                            image: "rok", 
                            price: 85000,
                            availableFabrics: [
                                FabricOption(id: "f65", type: "Katun", description: "Bahan katun nyaman", additionalPrice: 25000),
                                FabricOption(id: "f66", type: "Polyester", description: "Bahan polyester mudah dirawat", additionalPrice: 30000)
                            ]
                        )
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
