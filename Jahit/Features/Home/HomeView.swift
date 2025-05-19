//
//  HomeView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 06/05/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        VStack(spacing: 0) {
            SearchFieldHome(searchText: $viewModel.searchText)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                        Text(viewModel.formattedAddress ?? "Mendapatkan alamat...")
                            .font(.custom("PlusJakartaSans-Regular", size: 12))
                    }
                    
                    BannerCard()
                    
                    Text("Kategori")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    CategoriesButton()
                    
                    HStack {
                        Text("Penjahit terekemondasi")
                            .font(.headline)
                        Spacer()
                        Button("Lihat semua") {
                            // Action
                        }
                        .font(.subheadline)
                        .padding(8)
                        .background(Color(red: 0.82, green: 0.89, blue: 1.0))
                        .cornerRadius(15)
                    }
                    .padding(.top, 12)
                    
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
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
}
