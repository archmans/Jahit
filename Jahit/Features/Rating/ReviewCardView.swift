//
//  ReviewCardView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/06/25.
//

import SwiftUI

struct ReviewCardView: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with user info and rating
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ulasan Anda")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.black)
                    
                    Text(review.formattedDate)
                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Star rating
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                            .foregroundColor(star <= review.rating ? .yellow : .gray.opacity(0.3))
                            .font(.system(size: 14))
                    }
                }
            }
            
            // Comment
            if !review.comment.isEmpty {
                Text(review.comment)
                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Review images
            if !review.reviewImages.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Foto Ulasan")
                        .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.medium))
                        .foregroundColor(.gray)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 12) {
                        ForEach(review.reviewImages, id: \.self) { imageName in
                            ReviewImageView(imageName: imageName)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 0, green: 0.37, blue: 0.92).opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0, green: 0.37, blue: 0.92).opacity(0.2), lineWidth: 1)
        )
    }
}

struct ReviewImageView: View {
    let imageName: String
    
    var body: some View {
        Group {
            if let uiImage = ImageManager.shared.loadImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            } else {
                // Fallback to bundled image if saved image not found
                Image(imageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            }
        }
        .frame(width: 70, height: 60)
        .clipped()
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ReviewCardView(review: Review.sampleReview)
        .padding()
}
