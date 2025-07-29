//
//  ListTailorHorizontal.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/05/25.
//

import SwiftUI

struct ListTailorHorizontal: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<4) { _ in
                    Button(action: {
                        // Action
                    }) {
                        VStack(alignment: .center, spacing: 4) {
                            Image("penjahit")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .cornerRadius(8)
                                .frame(width: 120)

                            Text("Alfa Tailor")
                            .font(
                            Font.custom("Plus Jakarta Sans", size: 12)
                            .weight(.semibold)
                            )
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Mulai dari Rp100.000")
                                .font(Font.custom("PlusJakartaSans-Regular", size: 10))
                              .foregroundColor(.black)
                              .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("4.9")
                                    .font(Font.custom("PlusJakartaSans-Regular", size: 10))
                                .foregroundColor(.black)
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .padding(8)
                        .cornerRadius(12)
                        .overlay(
                        RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(.black.opacity(0.2), lineWidth: 1)

                        )
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.leading, 20)
        .frame(maxHeight: 197)
    }
}

#Preview {
    ListTailorHorizontal()
}
