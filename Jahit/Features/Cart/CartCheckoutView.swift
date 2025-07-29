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
            headerView
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    AddressComponent(showingAddressSheet: $showingAddressSheet)
                    
                    DateSelectionComponent(
                        selectedDate: $pickupDate,
                        showingDatePicker: $showingDatePicker
                    )
                    
                    TimeSelectionComponent(
                        selectedTime: $pickupTime,
                        showingTimePicker: $showingTimePicker
                    )
                    
                    DeliveryOptionComponent(
                        selectedDeliveryOption: $selectedDeliveryOption,
                        tailorLocationDescription: selectedItems.first.map { item in
                            LocalDatabase.shared.getTailor(by: item.tailorId)?.locationDescription
                        } ?? nil,
                        onSelectionChanged: { option in
                            selectedDeliveryOption = option
                        }
                    )
                    
                    orderSummaryView
                    
                    PaymentMethodComponent(
                        selectedPaymentMethod: $selectedPaymentMethod,
                        onSelectionChanged: { method in
                            selectedPaymentMethod = method
                        }
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
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
    
    private var orderSummaryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ringkasan Pemesanan")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 12) {
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
        guard !selectedItems.isEmpty,
              userManager.currentUser.address != nil,
              let pickupDate = pickupDate,
              let pickupTime = pickupTime,
              let selectedPaymentMethod = selectedPaymentMethod,
              let selectedDeliveryOption = selectedDeliveryOption else {
            print("Cannot process order: missing required fields")
            return
        }
        
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
            
            showingPaymentSuccess = true
        } else {
            print("Failed to process order")
        }
    }
}

#Preview {
    CartCheckoutView(selectedItems: CartItem.sampleItems)
        .environmentObject(UserManager.shared)
}
