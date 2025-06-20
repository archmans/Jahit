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
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarHidden(true)
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
    }
//             .background(Color(UIColor.systemGroupedBackground))
//             .sheet(isPresented: $viewModel.showingDatePicker) {
//                 DatePickerView(selectedDate: $viewModel.order.pickupDate, onDateSelected: viewModel.updatePickupDate)
//             }
//             .sheet(isPresented: $viewModel.showingTimePicker) {
//                 TimePickerView(selectedTime: $viewModel.order.pickupTime, onTimeSelected: viewModel.updatePickupTime)
//             }
//         }
//         .navigationBarHidden(true)
//     }
    
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
//         .padding(.vertical, 16)
//         .background(Color.white)
//     }
    
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
                Text("Alamat")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                if userManager.isLocationLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Button(action: {
                        userManager.forceUpdateLocation()
                    }) {
                        Image(systemName: "location.circle")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                }
            }
            
            Divider()
            
            HStack {
                TextField("Masukkan alamat Anda", text: Binding(
                    get: { 
                        // Use user's current address if available, otherwise use order address
                        return userManager.currentUser.address ?? viewModel.order.address 
                    },
                    set: { newAddress in
                        viewModel.updateAddress(newAddress)
                        // Optionally update user's address too
                        userManager.currentUser.address = newAddress
                        userManager.saveUserToStorage()
                    }
                ))
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
            
            // Show location error if any
            if let error = userManager.locationError {
                Text(error)
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.red)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pilih Tanggal Jemput")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.black)
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
            Text("Pilih Jam Jemput")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.black)
                .padding(.horizontal, 16)
            
            Button(action: {
                viewModel.showingTimePicker = true
            }) {
                HStack {
                    Text(viewModel.order.pickupTime.displayName)
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
//             }
//         }
//     }
    
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
//         .background(Color.white)
//         .cornerRadius(12)
//     }
    
    private var paymentMethodView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metode Pembayaran")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                .foregroundColor(.black)
            
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
//         .padding(16)
//         .background(Color.white)
//         .cornerRadius(12)
//     }
    
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
                viewModel.confirmOrder()
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
