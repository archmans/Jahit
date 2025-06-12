//
//  FilterView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 12/06/25.
//

import SwiftUI

struct FilterModalView: View {
    @ObservedObject var viewModel: FilterViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Text("Filter Penjahit")
                        .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Reset") {
                        viewModel.resetFilters()
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 24) {
                    // Sort Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Urutkan")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                            .foregroundColor(.black)
                        
                        HStack {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button(action: {
                                    viewModel.filterOptions.sortBy = option
                                }) {
                                    Text(option.displayName)
                                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                                        .foregroundColor(viewModel.filterOptions.sortBy == option ? .white : .black)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            viewModel.filterOptions.sortBy == option ?
                                            Color.blue : Color.gray.opacity(0.2)
                                        )
                                        .cornerRadius(20)
                                }
                            }
                            Spacer()
                        }
                    }
                    
                    // Price Range Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Rentang Harga")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 8) {
                            ForEach(PriceRange.allCases, id: \.self) { range in
                                HStack {
                                    Text(range.priceSymbol)
                                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.bold))
                                        .foregroundColor(.black)
                                        .frame(width: 40, alignment: .leading)
                                    
                                    Text(range.displayName)
                                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.togglePriceRange(range)
                                    }) {
                                        Image(systemName: viewModel.filterOptions.priceRanges.contains(range) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(viewModel.filterOptions.priceRanges.contains(range) ? .blue : .gray)
                                            .font(.system(size: 20))
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    // Service Type Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Jenis jahitan")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                            .foregroundColor(.black)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], alignment: .leading, spacing: 8) {
                            ForEach(ServiceType.allCases, id: \.self) { type in
                                Button(action: {
                                    viewModel.toggleServiceType(type)
                                }) {
                                    Text(type.displayName)
                                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                                        .foregroundColor(viewModel.filterOptions.serviceTypes.contains(type) ? .white : .black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            viewModel.filterOptions.serviceTypes.contains(type) ?
                                            Color.blue : Color.gray.opacity(0.2)
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Apply Filter Button
                Button(action: {
                    viewModel.applyFilters()
                }) {
                    Text("Pasang Filter")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white)
        }
    }
}

#Preview {
    FilterModalView(viewModel: FilterViewModel())
}
