//
//  TailorListItemSkeleton.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/06/25.
//

import SwiftUI

struct TailorListItemSkeleton: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 99, height: 99)
                .padding(.leading, 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .opacity(isAnimating ? 0.5 : 0.0)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 12)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 10)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 10)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5)
                .stroke(.black.opacity(0.2), lineWidth: 1)
        )
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                isAnimating = true
            }
        }
    }
}
