//
//  HomeView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 06/05/25.
//

import SwiftUI

struct OptionalStringIdentifiable: Identifiable, Equatable, Hashable {
    let value: String?
    var id: String? { value }
    
    static func == (lhs: OptionalStringIdentifiable, rhs: OptionalStringIdentifiable) -> Bool {
        lhs.value == rhs.value
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

struct HomeView: View {
    @StateObject private var tabBarVM = TabBarViewModel.shared
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedTailorId: OptionalStringIdentifiable? = nil
    @State private var searchTitle: String = ""
    @State private var isSearchViewPresented = false
    var body: some View {
        NavigationStack {
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
                        CategoriesButton(categories: viewModel.model.categories) { category in
                            searchTitle = category.capitalized
                            isSearchViewPresented = true
                        }
                        HStack {
                            Text("Penjahit terekemondasi")
                                .font(.headline)
                            Spacer()
                            Button("Lihat semua") {
                                searchTitle = "Semua Penjahit"
                                isSearchViewPresented = true
                            }
                                .font(.subheadline)
                                .padding(8)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        ListTailorHorizontal(tailors: viewModel.filteredTailors) { tailor in
                            selectedTailorId = OptionalStringIdentifiable(value: tailor.id)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                    .padding(.bottom, 80)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(item: $selectedTailorId) { idObj in
                if let id = idObj.value, let tailor = viewModel.filteredTailors.first(where: { $0.id == id }) {
                    TailorDetailView(tailor: tailor)
                }
            }
            .navigationDestination(isPresented: $isSearchViewPresented) {
                SearchView(searchTitle: $searchTitle)
            }
        }
        .onAppear {
            tabBarVM.show()
        }
    }
}

#Preview {
    HomeView()
}
