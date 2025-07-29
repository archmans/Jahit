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
    @State private var pickupDate: Date? = nil
    @State private var pickupTime: TimeSlot? = nil
    @State private var selectedPaymentMethod: PaymentMethod? = nil
    @State private var selectedDeliveryOption: DeliveryOption? = nil
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var showingAddressSheet = false
    @State private var showingPaymentSuccess = false
    
    var totalPrice: Double {
        let itemsTotal = selectedItems.reduce(0) { $0 + $1.totalPrice }
        let deliveryCost = selectedDeliveryOption?.additionalCost ?? 0
        return itemsTotal + deliveryCost
    }
    
    var formattedTotalPrice: String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: totalPrice)) ?? "Rp0"
    }
    
    var formattedPickupDate: String {
        guard let pickupDate = pickupDate else {
            return "Belum dipilih"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: pickupDate)
    }
    
    // Group items by tailor
    var groupedItems: [String: [CartItem]] {
        Dictionary(grouping: selectedItems, by: { $0.tailorName })
    }
    
    var isFormValid: Bool {
        let hasValidAddress = !(userManager.currentUser.address?.isEmpty ?? true)
        let hasPickupDate = pickupDate != nil
        let hasPickupTime = pickupTime != nil
        let hasPaymentMethod = selectedPaymentMethod != nil
        let hasDeliveryOption = selectedDeliveryOption != nil
        
        return hasValidAddress && hasPickupDate && hasPickupTime && hasPaymentMethod && hasDeliveryOption
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
                    
                    // Delivery Option
                    deliveryOptionView
                    
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
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .navigationBarHidden(true)
        .gesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .global)
                .onChanged { value in
                    if value.translation.width > 30 && abs(value.translation.height) < 100 {
                    }
                }
                .onEnded { value in
                    if value.translation.width > 50 && abs(value.translation.height) < 150 {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        dismiss()
                    }
                }
        )
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
        .fullScreenCover(isPresented: $showingPaymentSuccess) {
            PaymentSuccessView(onDismiss: {
                showingPaymentSuccess = false
                dismiss()
            })
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
                        .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
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
                .background(Color(red: 0, green: 0.37, blue: 0.92))
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
                    Text(pickupTime?.displayName ?? "Belum dipilih")
                        .font(.custom("PlusJakartaSans-Regular", size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0, green: 0.37, blue: 0.92))
                .cornerRadius(15)
            }
        }
    }
    
    private var deliveryOptionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 2) {
                Text("Pesanan diantar")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Text("*")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.red)
            }
            
            ForEach(DeliveryOption.allCases, id: \.self) { option in
                Button(action: {
                    selectedDeliveryOption = option
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: option == .delivery ? "truck.box" : "bag")
                            .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                            .font(.system(size: 20))
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(option.description)
                                .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                                .foregroundColor(.black)
                            
                            if let subtitle = option.subtitle {
                                Text(subtitle)
                                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                                    .foregroundColor(.gray)
                            } else if option == .pickup {
                                // For pickup, we need to get tailor location from the first item
                                if let firstItem = selectedItems.first {
                                    let tailor = LocalDatabase.shared.getTailor(by: firstItem.tailorId)
                                    Text(tailor?.locationDescription ?? "Lokasi tidak tersedia")
                                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if option.additionalCost > 0 {
                            Text("+\(NumberFormatter.currencyFormatter.string(from: NSNumber(value: option.additionalCost)) ?? "Rp15.000")")
                                .font(.custom("PlusJakartaSans-Regular", size: 10).weight(.bold))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(4)
                        }
                        
                        Image(systemName: selectedDeliveryOption == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selectedDeliveryOption == option ? Color(red: 0, green: 0.37, blue: 0.92) : .gray)
                            .font(.system(size: 20))
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
                
                if option != DeliveryOption.allCases.last {
                    Divider()
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
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
                            
                            if let fabricProvider = item.fabricProvider {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        if fabricProvider == .personal {
                                            Text("Bahan Pribadi")
                                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                                .foregroundColor(.green)
                                        } else if let fabricOption = item.selectedFabricOption {
                                            Text("Bahan \(fabricOption.type)")
                                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                                .foregroundColor(.orange)
                                            
                                            if item.fabricPrice > 0 {
                                                Text("Biaya bahan: \(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.fabricPrice * Double(item.quantity))) ?? "Rp0")")
                                                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            
                            // Custom Order Details
                            if item.isCustomOrder {
                                let hasDescription = item.customDescription != nil && !item.customDescription!.isEmpty
                                let hasImages = !item.referenceImages.isEmpty
                                
                                if hasDescription || hasImages {
                                    VStack(alignment: .leading, spacing: 6) {
                                        if hasDescription {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Deskripsi:")
                                                    .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.medium))
                                                    .foregroundColor(.gray)
                                                
                                                Text(item.customDescription!)
                                                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                                                    .foregroundColor(.black)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 6)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(6)
                                            }
                                        }
                                        
                                        if hasImages {
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
                        }
                        
                        if item != (groupedItems[tailorName] ?? []).last {
                            Divider()
                        }
                    }
                    
                    if tailorName != groupedItems.keys.sorted().last {
                        Divider()
                            .background(Color.black)
                            .frame(height: 2)
                    }
                }
            }
            
            Divider()
            
            // Show delivery cost if selected
            if let deliveryOption = selectedDeliveryOption, deliveryOption.additionalCost > 0 {
                HStack {
                    Text("Biaya \(deliveryOption.displayName.lowercased()):")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: deliveryOption.additionalCost)) ?? "Rp0")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.black)
                }
            }
            
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
                            .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
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
                            .foregroundColor(selectedPaymentMethod == method ? Color(red: 0, green: 0.37, blue: 0.92) : .gray)
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
                    .background(isFormValid ? Color(red: 0, green: 0.37, blue: 0.92) : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!isFormValid)
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1 : 0.6)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
    
    private func processOrder() {
        // Validate required fields
        guard !selectedItems.isEmpty,
              userManager.currentUser.address != nil,
              let pickupDate = pickupDate,
              let pickupTime = pickupTime,
              let selectedPaymentMethod = selectedPaymentMethod,
              let selectedDeliveryOption = selectedDeliveryOption else {
            print("Cannot process order: missing required fields")
            return
        }
        
        // Create transaction from cart items
        let success = userManager.createTransactionFromCart(
            selectedItems: selectedItems,
            pickupDate: pickupDate,
            pickupTime: pickupTime,
            paymentMethod: selectedPaymentMethod,
            deliveryOption: selectedDeliveryOption
        )
        
        if success {
            print("Order processed successfully!")
            print("Total: \(formattedTotalPrice)")
            print("Pickup Date: \(formattedPickupDate)")
            print("Pickup Time: \(pickupTime.displayName)")
            print("Payment Method: \(selectedPaymentMethod.displayName)")
            
            // Show payment success view
            showingPaymentSuccess = true
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
