//
//  RatingModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/06/25.
//

import Foundation

struct Review: Identifiable, Codable {
    let id: String
    let transactionId: String
    let tailorId: String
    let userId: String
    let userName: String
    let rating: Int
    let comment: String
    let reviewImages: [String]
    let createdDate: Date
    
    init(
        id: String = UUID().uuidString,
        transactionId: String,
        tailorId: String,
        userId: String,
        userName: String,
        rating: Int,
        comment: String,
        reviewImages: [String] = [],
        createdDate: Date = Date()
    ) {
        self.id = id
        self.transactionId = transactionId
        self.tailorId = tailorId
        self.userId = userId
        self.userName = userName
        self.rating = rating
        self.comment = comment
        self.reviewImages = reviewImages
        self.createdDate = createdDate
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: createdDate)
    }
    
    var starRating: String {
        return String(repeating: "★", count: rating) + String(repeating: "☆", count: 5 - rating)
    }
}

extension Review {
    static let sampleReview = Review(
        transactionId: "TXN-001",
        tailorId: "1",
        userId: "user-1",
        userName: "John Doe",
        rating: 5,
        comment: "Sangat puas dengan hasil jahitannya! Kualitas bagus dan sesuai ekspektasi.",
        reviewImages: ["blazer"],
        createdDate: Date()
    )
}
