//
//  CartView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Cart Items
                if viewModel.tailorCarts.flatMap({ $0.items }).isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.3))
                        Text("Keranjang kosong")
                            .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.medium))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.tailorCarts) { tailorCart in
                                VStack(spacing: 0) {
                                    tailorHeaderView(
                                        tailor: tailorCart.tailor,
                                        isSelectAll: tailorCart.isSelectAll,
                                        onSelectAll: { viewModel.toggleSelectAll(for: tailorCart.id) }
                                    )
                                    Divider()
                                    ForEach(tailorCart.items) { item in
                                        cartItemView(item: item)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Bottom Section
                if !viewModel.tailorCarts.flatMap({ $0.items }).isEmpty {
                    bottomSectionView
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .sheet(isPresented: $viewModel.showingCustomization) {
                CustomizationView()
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                // go to home
                
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .medium))
            }
            
            Text("Keranjang")
                .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private func tailorHeaderView(tailor: Tailor, isSelectAll: Bool, onSelectAll: @escaping () -> Void) -> some View {
        HStack(spacing: 8) {
            Button(action: onSelectAll) {
                Image(systemName: isSelectAll ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelectAll ? .blue : .gray)
                    .font(.system(size: 20))
            }
            Image("shop")
                .foregroundColor(.gray)
            Text(tailor.name)
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    private func cartItemView(item: CartItem) -> some View {
        HStack(spacing: 12) {
            Button(action: {
                viewModel.toggleItemSelection(item: item)
            }) {
                Image(systemName: item.isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(item.isSelected ? .blue : .gray)
                    .font(.system(size: 20))
            }
            
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.basePrice)) ?? "")
                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Quantity Controls
            HStack(spacing: 8) {
                Button(action: {
                    viewModel.updateQuantity(for: item, quantity: item.quantity - 1)
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                .disabled(item.quantity <= 1)
                
                Text("\(item.quantity)")
                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                    .foregroundColor(.black)
                    .frame(minWidth: 20)
                
                Button(action: {
                    viewModel.updateQuantity(for: item, quantity: item.quantity + 1)
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
        .padding(.leading, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Delete") {
                viewModel.removeItem(item)
            }
            .tint(.red)
        }
    }
    
    private var bottomSectionView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.toggleSelectAll()
                }) {
                    Image(systemName: viewModel.isSelectAll ? "checkmark.square.fill" : "square")
                        .foregroundColor(viewModel.isSelectAll ? .blue : .gray)
                        .font(.system(size: 20))
                }
                
                Text("Select All")
                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            HStack {
                Text("Total Price")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(viewModel.formattedTotalPrice)
                    .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                    .foregroundColor(.black)
            }
            
            Button(action: {
                viewModel.proceedToOrder()
            }) {
                Text("Pesan")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(viewModel.hasSelectedItems ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!viewModel.hasSelectedItems)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

#Preview {
    CartView()
}
