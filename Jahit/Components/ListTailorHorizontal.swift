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
                        VStack(alignment: .leading, spacing: 8) {
                            Image(tailor.profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 140, height: 100)
                                .clipped()
                                .cornerRadius(8)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(tailor.name)
                                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                                    .foregroundColor(.black)
                                    .lineLimit(1)

                                Text("Mulai dari Rp\(Int(tailor.services.first?.startingPrice ?? 0))")
                                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                                    .foregroundColor(.blue)

                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 10))
                                    Text(String(format: "%.1f", tailor.rating))
                                        .font(.custom("PlusJakartaSans-Regular", size: 10))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)
                        }
                        .frame(width: 140)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.vertical, 8)
        }
        .frame(maxHeight: 197)
    }
}

#Preview {
    ListTailorHorizontal(tailors: Tailor.sampleTailors, onTailorTap: { _ in })
}
