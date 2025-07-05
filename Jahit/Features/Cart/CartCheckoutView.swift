//
//  CartCheckoutView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 20/06/25.
//

import SwiftUI

struct CartCheckoutView: View {
    @StateObject private var tabBarVM = TabBarViewModel.shared
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    
    let selectedItems: [CartItem]
    @State private var pickupDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var pickupTime: TimeSlot = .morning
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var showingAddressSheet = false
    
    var totalPrice: Double {
        return selectedItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: totalPrice)) ?? "Rp0"
    }
    
    var formattedPickupDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: pickupDate)
    }
    
    // Group items by tailor
    var groupedItems: [String: [CartItem]] {
        Dictionary(grouping: selectedItems, by: { $0.tailorName })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Address
                    addressView
                    
                    // Date Selection
                    dateSelectionView
                    
                    // Time Selection
                    timeSelectionView
                    
                    // Order Summary
                    orderSummaryView
                    
                    // Payment Method
                    paymentMethodView
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            // Bottom Section
            bottomSectionView
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarHidden(true)
        .onAppear {
            tabBarVM.hide()
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $pickupDate, onDateSelected: { date in
                pickupDate = date
                showingDatePicker = false
            })
        }
        .sheet(isPresented: $showingTimePicker) {
            TimePickerView(selectedTime: $pickupTime, onTimeSelected: { time in
                pickupTime = time
                showingTimePicker = false
            })
        }
        .sheet(isPresented: $showingAddressSheet) {
            AddressEditSheet(
                currentAddress: userManager.currentUser.address ?? "",
                currentName: userManager.currentUser.name,
                currentPhone: userManager.currentUser.phoneNumber ?? "",
                onSave: { newAddress, newName, newPhone in
                    userManager.currentUser.address = newAddress
                    userManager.currentUser.name = newName
                    userManager.currentUser.phoneNumber = newPhone
                    userManager.saveUserToStorage()
                }
            )
            .environmentObject(userManager)
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
            
            Text("Pembayaran")
                .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var addressView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 2) {
                    Text("Alamat")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                        .foregroundColor(.black)
                    
                    Text("*")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button(action: {
                    showingAddressSheet = true
                }) {
                    Text("Ubah Alamat")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.blue)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                // Name - Phone Number on same line
                HStack(spacing: 8) {
                    Text(userManager.currentUser.name.isEmpty ? "Nama belum diset" : userManager.currentUser.name)
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                        .foregroundColor(userManager.currentUser.name.isEmpty ? .gray : .black)
                    
                    Text("-")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.gray)
                    
                    Text(userManager.currentUser.phoneNumber?.isEmpty != false ? "Nomor handphone belum diset" : userManager.currentUser.phoneNumber!)
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(userManager.currentUser.phoneNumber?.isEmpty != false ? .gray : .black)
                }
                
                // Address with location icon on separate line
                HStack(spacing: 8) {
                    Image("location")
                        .foregroundColor(.red)
                    
                    if userManager.isLocationLoading {
                        Text("Mendapatkan alamat...")
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                    } else if let address = userManager.currentUser.address, !address.isEmpty {
                        Text(address)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.black)
                    } else {
                        Text("Alamat belum diset")
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                Text("Pilih Tanggal Jemput")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Text("*")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 16)
            
            Button(action: {
                showingDatePicker = true
            }) {
                HStack {
                    Text(formattedPickupDate)
                        .font(.custom("PlusJakartaSans-Regular", size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(15)
            }
        }
    }
    
    private var timeSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                Text("Pilih Jam Jemput")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Text("*")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 16)
            
            Button(action: {
                showingTimePicker = true
            }) {
                HStack {
                    Text(pickupTime.displayName)
                        .font(.custom("PlusJakartaSans-Regular", size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(15)
            }
        }
    }
    
    private var orderSummaryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ringkasan Pemesanan")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                .foregroundColor(.black)
            
            ForEach(Array(groupedItems.keys.sorted()), id: \.self) { tailorName in
                VStack(alignment: .leading, spacing: 8) {
                    Text(tailorName)
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                        .foregroundColor(.black)
                    
                    ForEach(groupedItems[tailorName] ?? [], id: \.id) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.itemName)
                                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("x \(item.quantity)")
                                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.totalPrice)) ?? "Rp0")
                                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                                    .foregroundColor(.black)
                            }
                            
                            // Custom Order Details
                            if item.isCustomOrder {
                                Divider()
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Detail Kustomisasi")
                                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                                        .foregroundColor(.black)
                                    
                                    // Description
                                    if let description = item.customDescription, !description.isEmpty {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Deskripsi:")
                                                .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.medium))
                                                .foregroundColor(.gray)
                                            
                                            Text(description)
                                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                                .foregroundColor(.black)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 6)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(6)
                                        }
                                    }
                                    
                                    // Reference Images
                                    if !item.referenceImages.isEmpty {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Gambar Referensi (\(item.referenceImages.count)):")
                                                .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.medium))
                                                .foregroundColor(.gray)
                                            
                                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                                                ForEach(item.referenceImages, id: \.self) { imageName in
                                                    Group {
                                                        if let uiImage = ImageManager.shared.loadImage(named: imageName) {
                                                            Image(uiImage: uiImage)
                                                                .resizable()
                                                                .aspectRatio(1, contentMode: .fill)
                                                        } else {
                                                            Image(imageName)
                                                                .resizable()
                                                                .aspectRatio(1, contentMode: .fill)
                                                        }
                                                    }
                                                    .frame(width: 50, height: 50)
                                                    .clipped()
                                                    .cornerRadius(6)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if item != (groupedItems[tailorName] ?? []).last {
                            Divider()
                        }
                    }
                    
                    if tailorName != groupedItems.keys.sorted().last {
                        Divider()
                            .background(Color.blue)
                            .frame(height: 2)
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Total:")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(formattedTotalPrice)
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var paymentMethodView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 2) {
                Text("Metode Pembayaran")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                Text("*")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.red)
            }
            
            ForEach(PaymentMethod.allCases, id: \.self) { method in
                Button(action: {
                    selectedPaymentMethod = method
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: method.icon)
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(method.displayName)
                                .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                                .foregroundColor(.black)
                            
                            if let subtitle = method.subtitle {
                                Text(subtitle)
                                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selectedPaymentMethod == method ? .blue : .gray)
                            .font(.system(size: 20))
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
                
                if method != PaymentMethod.allCases.last {
                    Divider()
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var bottomSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Total Price")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(formattedTotalPrice)
                    .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                    .foregroundColor(.black)
            }
            
            Button(action: {
                processOrder()
            }) {
                Text("Konfirmasi")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
    
    private func processOrder() {
        // Validate required fields
        guard !selectedItems.isEmpty,
              userManager.currentUser.address != nil else {
            print("Cannot process order: missing items or address")
            return
        }
        
        // Create transaction from cart items
        let success = userManager.createTransactionFromCart(
            selectedItems: selectedItems,
            pickupDate: pickupDate,
            pickupTime: pickupTime,
            paymentMethod: selectedPaymentMethod
        )
        
        if success {
            print("Order processed successfully!")
            print("Total: \(formattedTotalPrice)")
            print("Pickup Date: \(formattedPickupDate)")
            print("Pickup Time: \(pickupTime.displayName)")
            print("Payment Method: \(selectedPaymentMethod.displayName)")
            
            // Navigate back
            dismiss()
        } else {
            print("Failed to process order")
            // TODO: Show error alert to user
        }
    }
}

#Preview {
    CartCheckoutView(selectedItems: CartItem.sampleItems)
        .environmentObject(UserManager.shared)
}
