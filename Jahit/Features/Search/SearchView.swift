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
    @StateObject private var viewModel: SearchViewModel
    @StateObject private var tabBarVM = TabBarViewModel.shared
    
    init(searchTitle: Binding<String>) {
        self._searchTitle = searchTitle
        self._viewModel = StateObject(wrappedValue: SearchViewModel(category: searchTitle.wrappedValue))
        print("SearchView: Initializing with category: \(searchTitle.wrappedValue)")
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
        .navigationBarHidden(true)
        .onAppear {
            print("SearchView: onAppear called")
            tabBarVM.hide()
        }
    }
}

struct TailorGridItem: View {
    let tailor: Tailor
    
    // Computed property to cache the services string
    private var servicesText: String {
        tailor.services.map { $0.name }.joined(separator: ", ")
    }
    
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
                        .foregroundColor(.blue)
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

struct TailorListItem: View {
    let tailor: Tailor
    
    // Computed property to cache the services string
    private var servicesText: String {
        tailor.services.map { $0.name }.joined(separator: ", ")
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(tailor.profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .cornerRadius(8)
                .frame(width: 99, height: 99)
                .padding(.leading, 4)
            VStack(spacing: 4) {
                Text(tailor.name)
                    .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    Text(String(format: "%.1f", tailor.rating))
                        .font(.custom("PlusJakartaSans-Regular", size: 10))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(servicesText)
                    .font(.custom("PlusJakartaSans-Regular", size: 10).weight(.light))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(tailor.location)
                    .font(.custom("PlusJakartaSans-Regular", size: 10).weight(.light))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5)
                .stroke(.black.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    SearchView(searchTitle: .constant("Terekomendasi"))
}
