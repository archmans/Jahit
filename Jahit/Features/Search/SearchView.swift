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
                LazyVStack(alignment: .leading, spacing: 8) {
                    if viewModel.isLoading {
                        ForEach(0..<5, id: \.self) { _ in
                            TailorListItemSkeleton()
                                .padding(.vertical, 6)
                        }
                    } else {
                        ForEach(viewModel.tailors) { tailor in
                            NavigationLink(destination: TailorDetailView(tailor: tailor)) {
                                TailorListItem(tailor: tailor)
                                    .padding(.vertical, 6)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .animation(.default, value: viewModel.isLoading)
                .animation(.default, value: viewModel.tailors)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            tabBarVM.hide()
        }
    }
}

struct TailorListItem: View {
    let tailor: Tailor
    
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
                    .font(Font.custom("Plus Jakarta Sans", size: 12).weight(.semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    Text(String(format: "%.1f", tailor.rating))
                        .font(Font.custom("PlusJakartaSans-Regular", size: 10))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(tailor.services.map { $0.name }.joined(separator: ", "))
                    .font(Font.custom("PlusJakartaSans-Regular", size: 10).weight(.light))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(tailor.location)
                    .font(Font.custom("PlusJakartaSans-Regular", size: 10).weight(.light))
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
