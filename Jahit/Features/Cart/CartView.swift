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
    @State private var showingCheckout = false
    
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
                
                bottomCheckoutView
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showingCheckout) {
            CartCheckoutView(selectedItems: userManager.currentUser.selectedCartItems)
        }
        .onAppear {
            tabBarVM.hide()
        }
    }
    
    private var headerView: some View {
        ZStack {
            Text("Keranjang")
                .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                .foregroundColor(.black)
            
            HStack {
                Button(action: {
                    dismiss()
                    tabBarVM.show()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: 24, weight: .medium))
                }
                
                Spacer()
                
                if !userManager.currentUser.selectedCartItems.isEmpty {
                    Button(action: {
                        deleteSelectedItems()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                } else {
                    Image(systemName: "trash")
                        .foregroundColor(.clear)
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
                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    
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
                if !userManager.currentUser.selectedCartItems.isEmpty {
                    showingCheckout = true
                }
                // If no items selected, button does nothing (disabled state)
            }) {
                Text(userManager.currentUser.selectedCartItems.isEmpty ? "Pilih item terlebih dahulu" : "Lanjut ke Pembayaran")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(userManager.currentUser.selectedCartItems.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
            }
            .disabled(userManager.currentUser.selectedCartItems.isEmpty)
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
