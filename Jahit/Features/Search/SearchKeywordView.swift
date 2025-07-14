//
//  SearchKeywordView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 06/05/25.
//

import SwiftUI

struct SearchKeywordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SearchKeywordViewModel()
    @StateObject private var tabBarVM = TabBarViewModel.shared
    @State private var searchText: String = ""
    @State private var selectedTailorId: OptionalStringIdentifiable? = nil
    @State private var selectedProductForCustomization: (ProductSearchResult, Tailor, TailorService)? = nil
    @State private var showingCustomization = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with search field
            headerView
            
            // Results
            ScrollView {
                if !searchText.isEmpty {
                    searchSummaryView
                    .padding(.vertical, 8)
                }
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.searchResults.isEmpty && !searchText.isEmpty {
                    emptyView
                } else if !viewModel.searchResults.isEmpty {
                    resultsGridView
                }
            }
            .padding(.horizontal, 20)
            .background(Color.white)
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 && abs(value.translation.height) < 50 {
                        dismiss()
                        tabBarVM.show()
                    }
                }
        )
        .onAppear {
            tabBarVM.hide()
        }
        .navigationDestination(item: $selectedTailorId) { idObj in
            if let id = idObj.value, 
               let result = viewModel.searchResults.first(where: { 
                   if case .tailor(let tailor) = $0 { return tailor.id == id }
                   return false
               }),
               case .tailor(let tailor) = result {
                TailorDetailView(tailor: tailor)
            }
        }
        .navigationDestination(isPresented: $showingCustomization) {
            if let (product, tailor, service) = selectedProductForCustomization {
                CustomizationView(tailor: tailor, service: service, preSelectedProduct: product)
            }
        }
        .onChange(of: showingCustomization) { _, newValue in
            if !newValue {
                selectedProductForCustomization = nil
            }
        }
    }
    
    private var headerView: some View {
        ZStack(alignment: .top) {
            HeaderBackground()
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button(action: {
                        dismiss()
                        tabBarVM.show()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .medium))
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                            .font(.system(size: 16))
                        
                        TextField("Cari produk atau penjahit...", text: $searchText)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.black)
                            .onSubmit {
                                viewModel.search(query: searchText)
                            }
                            .onChange(of: searchText) { _, newValue in
                                if newValue.count >= 3 {
                                    viewModel.search(query: newValue)
                                } else if newValue.isEmpty {
                                    viewModel.clearResults()
                                }
                            }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
        }
        .frame(height: 70)
    }
    
    private var searchSummaryView: some View {
        HStack {
            let productCount = viewModel.searchResults.filter { 
                if case .product = $0 { return true }
                return false
            }.count
            
            let tailorCount = viewModel.searchResults.filter { 
                if case .tailor = $0 { return true }
                return false
            }.count
            
            if productCount > 0 {
                Text("\(productCount) Produk ditemukan")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            
            if productCount > 0 && tailorCount > 0 {
                Text("\(productCount) Produk dan \(tailorCount) Penjahit ditemukan")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            
            if tailorCount > 0 {
                Text("\(tailorCount) Penjahit ditemukan")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Mencari...")
                .font(.custom("PlusJakartaSans-Regular", size: 16))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
        .background(Color.white)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("Tidak ada hasil ditemukan")
                .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                .foregroundColor(.gray)
            Text("Coba kata kunci lain")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
        .background(Color.white)
    }
    
    private var resultsGridView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ], spacing: 16) {
            ForEach(viewModel.searchResults) { result in
                switch result {
                case .product(let product):
                    ProductSearchCard(product: product) {
                        if let tailor = Tailor.sampleTailors.first(where: { $0.id == product.tailorId }),
                           let service = tailor.services.first(where: { $0.name == product.category }) {
                            selectedProductForCustomization = (product, tailor, service)
                            showingCustomization = true
                        }
                    }
                case .tailor(let tailor):
                    TailorSearchCard(tailor: tailor) {
                        selectedTailorId = OptionalStringIdentifiable(value: tailor.id)
                    }
                }
            }
        }
    }
}

struct ProductSearchCard: View {
    let product: ProductSearchResult
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Product Image
                Image(product.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Product Name
                    Text(product.name)
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    // Price
                    Text("Rp \(Int(product.price).formatted())")
                        .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.bold))
                        .foregroundColor(.black)
                    
                    // Tailor Name
                    Text(product.tailorName)
                        .font(.custom("PlusJakartaSans-Regular", size: 10))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct TailorSearchCard: View {
    let tailor: Tailor
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
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
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    SearchKeywordView()
}
