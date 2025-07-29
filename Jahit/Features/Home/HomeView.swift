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
        VStack(alignment: .leading, spacing: 0) {
            SearchFieldHome(searchText: $viewModel.searchText)
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    LocationLabel()
                    BannerCard()
                        .padding(.horizontal, 20)
                    
                    Text("Kategori")
                        .font(.headline)
                        .padding(.top, 8)
                        .padding(.horizontal, 20)
                    
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
                    .padding(.horizontal, 20)
                    
                    ListTailorHorizontal()
                    
                    HStack {
                        Text("Penjahit terdekat")
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
                    .padding(.horizontal, 20)
                    
                    
                    ListTailorHorizontal()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 80)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
}
