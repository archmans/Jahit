//
//  CategoriesButton.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/05/25.
//

import SwiftUI

struct CategoriesButton: View {
    let categories: [String]
    var onCategoryTap: ((String) -> Void)? = nil
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 12) {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    onCategoryTap?(category)
                }) {
                    HStack(spacing: 8) {
                        Image(category.lowercased())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Text(getCategoryDisplayName(category))
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
    }
    
    private func getCategoryDisplayName(_ category: String) -> String {
        switch category.lowercased() {
        case "atasan":
            return "Atasan"
        case "bawahan":
            return "Bawahan"
        case "terusan":
            return "Terusan"
        case "perbaikan":
            return "Perbaikan"
        default:
            return category.capitalized
        }
    }
}

#Preview {
    CategoriesButton(categories: ["atasan", "bawahan", "terusan", "perbaikan"]) { category in
        print("Tapped: \(category)")
    }
    .padding()
}
