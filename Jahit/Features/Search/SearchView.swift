//
//  SearchView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/05/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchTitle: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var tabBarVM = TabBarViewModel.shared
    
    init(searchTitle: Binding<String>) {
        self._searchTitle = searchTitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                HeaderBackground()
                HStack(spacing: 12) {
                    Button(action: {
                        dismiss()
                        tabBarVM.show()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .medium))
                    }
                    Text(searchTitle)
                        .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 70)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.isLoading {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ], spacing: 16) {
                            ForEach(0..<6, id: \.self) { _ in
                                TailorGridItemSkeleton()
                            }
                        }
                    } else if viewModel.tailors.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "person.3")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("Tidak ada penjahit ditemukan")
                                .font(.custom("PlusJakartaSans-Regular", size: 16))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ], spacing: 16) {
                            ForEach(viewModel.tailors) { tailor in
                                NavigationLink(destination: TailorDetailView(tailor: tailor)) {
                                    TailorGridItem(tailor: tailor)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            tabBarVM.hide()
            viewModel.setCategory(searchTitle)
        }
    }
}

struct TailorGridItem: View {
    let tailor: Tailor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Tailor Image
            Image(tailor.profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipped()
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                // Tailor Name
                Text(tailor.name)
                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                // Starting Price
                if let minPrice = tailor.services.flatMap({ $0.items }).map({ $0.price }).min() {
                    Text("Mulai dari Rp \(Int(minPrice).formatted())")
                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                        .foregroundColor(.black)
                }
                
                // Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 10))
                    Text(String(format: "%.1f", tailor.rating))
                        .font(.custom("PlusJakartaSans-Regular", size: 10))
                        .foregroundColor(.gray)
                }
                
                // Location
                Text(tailor.location)
                    .font(.custom("PlusJakartaSans-Regular", size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct TailorGridItemSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image skeleton
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
            
            VStack(alignment: .leading, spacing: 4) {
                // Name skeleton
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 14)
                
                // Price skeleton
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 12)
                
                // Rating skeleton
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 10)
                }
                
                // Location skeleton
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 10)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    SearchView(searchTitle: .constant("Terekomendasi"))
}
