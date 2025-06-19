//
//  ListTailorHorizontal.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/05/25.
//

import SwiftUI

struct ListTailorHorizontal: View {
    let tailors: [Tailor]
    var onTailorTap: ((Tailor) -> Void)? = nil
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                Spacer(minLength: 0)
                ForEach(tailors, id: \.id) { tailor in
                    Button(action: {
                        onTailorTap?(tailor)
                    }) {
                        VStack(alignment: .center, spacing: 4) {
                            Image(tailor.profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .cornerRadius(8)
                                .frame(width: 120)

                            Text(tailor.name)
                                .font(
                                    Font.custom("Plus Jakarta Sans", size: 12)
                                        .weight(.semibold)
                                )
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Mulai dari Rp\(Int(tailor.services.first?.startingPrice ?? 0))")
                                .font(Font.custom("PlusJakartaSans-Regular", size: 10))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", tailor.rating))
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
                Spacer(minLength: 0)
            }
        }
        .padding(.top, 8)
        .frame(maxHeight: 197)
    }
}

#Preview {
    ListTailorHorizontal(tailors: Tailor.sampleTailors, onTailorTap: { _ in })
}
