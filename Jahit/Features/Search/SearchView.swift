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
    @State private var selectedTailorId: String? = nil
    
    init(searchTitle: Binding<String>) {
        self._searchTitle = searchTitle
        self._viewModel = StateObject(wrappedValue: SearchViewModel(category: searchTitle.wrappedValue))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .top) {
                    HeaderBackground()
                    HStack(spacing: 12) {
                        Button(action: {
                            dismiss()
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
                
                // Filter button
                HStack {
                    Button(action: {}) {
                        Image("filter")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(red: 0.82, green: 0.89, blue: 1.0))
                    .cornerRadius(15)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        if viewModel.isLoading {
                            ForEach(0..<5, id: \.self) { _ in
                                TailorListItemSkeleton()
                            }
                        } else {
                            ForEach(viewModel.tailors) { tailor in
                                Button(action: {
                                    selectedTailorId = tailor.id
                                }) {
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
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: String.self) { tailorId in
                if let tailor = viewModel.tailors.first(where: { $0.id == tailorId }) {
                    TailorDetailView(tailor: tailor)
                }
            }
        }
    }
}

#Preview {
    SearchView(searchTitle: .constant("Terekomendasi"))
}
