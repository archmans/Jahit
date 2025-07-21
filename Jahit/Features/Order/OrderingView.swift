//
//  OrderingView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI

struct OrderingView: View {
    @StateObject private var viewModel: OrderingViewModel
    @StateObject private var tabBarVM = TabBarViewModel.shared
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddressSheet = false
    @State private var showingPaymentSuccess = false
    
    let customizationOrder: CustomizationOrder
    
    init(customizationOrder: CustomizationOrder) {
        self.customizationOrder = customizationOrder
        self._viewModel = StateObject(wrappedValue: OrderingViewModel(customizationOrder: customizationOrder))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Tailor Name
                    tailorNameView
                    Divider()
                    
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
            // Sync user's current address to the order
            if let userAddress = userManager.currentUser.address {
                viewModel.updateAddress(userAddress)
            }
        }
        .sheet(isPresented: $viewModel.showingDatePicker) {
            DatePickerView(selectedDate: $viewModel.order.pickupDate, onDateSelected: viewModel.updatePickupDate)
        }
        .sheet(isPresented: $viewModel.showingTimePicker) {
            TimePickerView(selectedTime: $viewModel.order.pickupTime, onTimeSelected: viewModel.updatePickupTime)
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
            
            Text("Pemesanan")
                .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var tailorNameView: some View {
        HStack(spacing: 12) {
            Image("shop")
            Text(viewModel.order.tailorName)
                .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                .foregroundColor(.black)
        }
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
        .sheet(isPresented: $showingAddressSheet) {
            AddressEditSheet(
                currentAddress: userManager.currentUser.address ?? "",
                currentName: userManager.currentUser.name,
                currentPhone: userManager.currentUser.phoneNumber ?? "",
                onSave: { newAddress, newName, newPhone in
                    viewModel.updateAddress(newAddress)
                    userManager.currentUser.address = newAddress
                    userManager.currentUser.name = newName
                    userManager.currentUser.phoneNumber = newPhone
                    userManager.saveUserToStorage()
                }
            )
            .environmentObject(userManager)
        }
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
                viewModel.showingDatePicker = true
            }) {
                HStack {
                    Text(viewModel.formattedPickupDate)
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
                viewModel.showingTimePicker = true
            }) {
                HStack {
                    Text(viewModel.order.pickupTime?.displayName ?? "Belum dipilih")
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
            
            Text(viewModel.order.tailorName)
                .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                .foregroundColor(.black)
            
            ForEach(viewModel.order.items, id: \.name) { item in
                HStack {
                    Text("\(item.name)")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.black)
                    
                    Spacer()
                    Text("x \(item.quantity)")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.black)
                    Spacer()
                    
                    Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.totalPrice)) ?? "")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.black)
                }
            }
            
            // Custom Order Details
            if !customizationOrder.description.isEmpty || !customizationOrder.referenceImages.isEmpty {
                // Description
                if !customizationOrder.description.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Deskripsi:")
                            .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.medium))
                            .foregroundColor(.gray)
                        
                        Text(customizationOrder.description)
                            .font(.custom("PlusJakartaSans-Regular", size: 12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                
                // Reference Images
                if !customizationOrder.referenceImages.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Gambar Referensi (\(customizationOrder.referenceImages.count)):")
                            .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.medium))
                            .foregroundColor(.gray)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                            ForEach(customizationOrder.referenceImages, id: \.self) { imageName in
                                Group {
                                    if let uiImage = ImageManager.shared.loadImage(named: imageName) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fill)
                                    } else {
                                        // Fallback to bundled image if saved image not found
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
            
            Divider()
            
            HStack {
                Text("Total:")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(viewModel.formattedTotalPrice)
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
                    viewModel.selectPaymentMethod(method)
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
                        
                        Image(systemName: viewModel.selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(viewModel.selectedPaymentMethod == method ? .blue : .gray)
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
                
                Text(viewModel.formattedTotalPrice)
                    .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                    .foregroundColor(.black)
            }
            
            Button(action: {
                let success = viewModel.confirmOrder()
                if success {
                    showingPaymentSuccess = true
                }
            }) {
                Text("Konfirmasi")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(viewModel.isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!viewModel.isFormValid)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

struct AddressEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userManager: UserManager
    @State private var addressText: String
    @State private var nameText: String
    @State private var phoneText: String
    @State private var tempAddress: String = ""
    
    let onSave: (String, String, String) -> Void
    
    init(currentAddress: String, currentName: String, currentPhone: String, onSave: @escaping (String, String, String) -> Void) {
        self._addressText = State(initialValue: currentAddress)
        self._nameText = State(initialValue: currentName)
        self._phoneText = State(initialValue: currentPhone)
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with drag indicator
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 4)
                
                HStack {
                    Text("Ubah Alamat")
                        .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Tutup") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Description
            Text("Masukkan nama, nomor telepon, dan alamat lengkap")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
                
                // Name and Phone Number fields
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nama")
                            .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                            .foregroundColor(.black)
                        
                        TextField("Masukkan nama", text: $nameText)
                            .font(.custom("PlusJakartaSans-Regular", size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.black)
                            .accentColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nomor Handphone")
                            .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                            .foregroundColor(.black)
                        
                        TextField("Masukkan nomor handphone", text: $phoneText)
                            .font(.custom("PlusJakartaSans-Regular", size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.black)
                            .accentColor(.blue)
                            .keyboardType(.phonePad)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 20)
                // Divider
                Divider()
                    .padding(.horizontal, 20)
                
                // Address Section Title
                Text("Alamat")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                // Auto location button
                Button(action: {
                    userManager.forceUpdateLocation()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 24))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Gunakan Lokasi Saat Ini")
                                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                                .foregroundColor(.black)
                            
                            if userManager.isLocationLoading {
                                Text("Mendapatkan lokasi...")
                                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                                    .foregroundColor(.gray)
                            } else {
                                Text("Otomatis mendeteksi alamat Anda")
                                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        if userManager.isLocationLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                .disabled(userManager.isLocationLoading)
                .padding(.horizontal, 20)
                
                // Manual address input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Atau masukkan alamat manual")
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                        .foregroundColor(.black)
                    
                    TextField("Masukkan alamat lengkap Anda", text: $addressText, axis: .vertical)
                        .font(.custom("PlusJakartaSans-Regular", size: 16))
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.black)
                        .accentColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .lineLimit(5, reservesSpace: true)
                }
                .padding(.horizontal, 20)
                
                // Show location error if any
                if let error = userManager.locationError {
                    Text(error)
                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Save button
                Button(action: {
                    onSave(addressText, nameText, phoneText)
                    dismiss()
                }) {
                    Text("Simpan Alamat")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background((addressText.isEmpty || nameText.isEmpty || phoneText.isEmpty) ? Color.gray : Color.blue)
                        .cornerRadius(12)
                }
                .disabled(addressText.isEmpty || nameText.isEmpty || phoneText.isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        .background(Color.white)
        .onChange(of: userManager.currentUser.address) { _, newAddress in
            // Update addressText when location is updated
            if let newAddress = newAddress, !newAddress.isEmpty {
                addressText = newAddress
            }
        }
        .onAppear {
            // Sync current data when sheet appears
            if let currentAddress = userManager.currentUser.address, !currentAddress.isEmpty {
                addressText = currentAddress
            }
            nameText = userManager.currentUser.name
            phoneText = userManager.currentUser.phoneNumber ?? ""
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    let sampleOrder = CustomizationOrder(
        tailorId: "1",
        tailorName: "Alfa Tailor",
        category: "Atasan"
    )
    return OrderingView(customizationOrder: sampleOrder)
        .environmentObject(UserManager.shared)
}
