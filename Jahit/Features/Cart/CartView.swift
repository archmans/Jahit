//
//  CartView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject private var tabBarVM = TabBarViewModel.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Cart Items
            if userManager.currentUser.cart.isEmpty {
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
                        ForEach(userManager.currentUser.cart) { tailorCart in
                            VStack(spacing: 0) {
                                tailorHeaderView(tailorCart: tailorCart)
                                Divider()
                                ForEach(tailorCart.items) { item in
                                    cartItemView(item: item)
                                }
                            }
                        }
                    }
                }
                
                // Bottom checkout section
                if !userManager.currentUser.selectedCartItems.isEmpty {
                    bottomCheckoutView
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            tabBarVM.hide()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .medium))
            }
            
            Spacer()
            
            Text("Keranjang")
                .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                .foregroundColor(.black)
            
            Spacer()
            
            // Delete selected items button - only show when items are selected
            if !userManager.currentUser.selectedCartItems.isEmpty {
                Button(action: {
                    deleteSelectedItems()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private func tailorHeaderView(tailorCart: TailorCart) -> some View {
        HStack {
            Button(action: {
                userManager.toggleSelectAllForTailor(tailorId: tailorCart.tailorId)
            }) {
                Image(systemName: tailorCart.isSelectAll ? "checkmark.square.fill" : "square")
                    .foregroundColor(tailorCart.isSelectAll ? .blue : .gray)
                    .font(.system(size: 20))
            }
            
            Text(tailorCart.tailorName)
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGray6))
    }
    
    private func cartItemView(item: CartItem) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: {
                    userManager.toggleCartItemSelection(itemId: item.id, tailorId: item.tailorId)
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
                    
                    Text(item.category)
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.gray)
                    
                    if item.isCustomOrder {
                        Text("Custom Order")
                            .font(.custom("PlusJakartaSans-Regular", size: 12))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.basePrice)) ?? "Rp0")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.black)
                    
                    Text("Total: \(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.totalPrice)) ?? "Rp0")")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Button(action: {
                            userManager.updateCartItemQuantity(itemId: item.id, tailorId: item.tailorId, quantity: item.quantity - 1)
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
                            userManager.updateCartItemQuantity(itemId: item.id, tailorId: item.tailorId, quantity: item.quantity + 1)
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Additional details for custom orders
            if item.isCustomOrder {
                VStack(alignment: .leading, spacing: 8) {
                    if let description = item.customDescription, !description.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Deskripsi Custom:")
                                .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.semibold))
                                .foregroundColor(.gray)
                            
                            Text(description)
                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                    
                    if !item.referenceImages.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Gambar Referensi:")
                                .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.semibold))
                                .foregroundColor(.gray)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(item.referenceImages, id: \.self) { imageName in
                                        Image(imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 40, height: 40)
                                            .clipped()
                                            .cornerRadius(6)
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        }
        .background(Color.white)
    }
    
    private var bottomCheckoutView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Total (\(userManager.currentUser.selectedCartItems.count) item)")
                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: userManager.currentUser.totalCartPrice)) ?? "Rp0")
                    .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                    .foregroundColor(.black)
            }
            
            Button(action: {
                // Navigate to checkout
                print("Proceed to checkout")
            }) {
                Text("Lanjut ke Pembayaran")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
    
    private func deleteSelectedItems() {
        let selectedItems = userManager.currentUser.selectedCartItems
        
        for item in selectedItems {
            userManager.removeFromCart(itemId: item.id, tailorId: item.tailorId)
        }
    }
}

#Preview {
    CartView()
        .environmentObject(UserManager.shared)
}
