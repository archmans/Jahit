//
//  TransactionDetailView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 12/06/25.
//

import SwiftUI

struct OrderDetailView: View {
    @StateObject private var viewModel = OrderDetailViewModel()
    
    var body: some View {
        headerView
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Progress Steps
                progressStepsView
                
                // Order Content
                orderContentView
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                viewModel.goBack()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .medium))
            }
            
            Text("Rincian Pesanan")
                .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var progressStepsView: some View {
        VStack(spacing: 16) {
            HStack {
                ForEach(Array(OrderStatus.allCases.enumerated()), id: \.offset) { index, status in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(index <= viewModel.currentStepIndex ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: status.icon)
                                .foregroundColor(index <= viewModel.currentStepIndex ? .white : .gray)
                                .font(.system(size: 16))
                        }
                        
                        Text(index == 1 ? "Sedang\ndijahit" : status.rawValue.replacingOccurrences(of: " ", with: "\n"))
                            .font(.custom("PlusJakartaSans-Regular", size: 10))
                            .foregroundColor(index <= viewModel.currentStepIndex ? .blue : .gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity)
                    
                    if index < OrderStatus.allCases.count - 1 {
                        HStack(spacing: 2) {
                            ForEach(0..<8, id: \.self) { _ in
                                Circle()
                                    .fill(index < viewModel.currentStepIndex ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 3, height: 3)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var orderContentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(viewModel.order.tailorName)
                .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.7))
                .cornerRadius(12)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                // Category
                orderDetailRow(title: "Kategori", value: viewModel.order.category)
                
                // Item
                orderDetailRow(title: "Item", value: viewModel.order.item)
                
                // Reference Images
                VStack(alignment: .leading, spacing: 8) {
                    Text("Referensi Gambar")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 12) {
                        ForEach(viewModel.order.referenceImages, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(8)
                        }
                        Spacer()
                    }
                }
                
                // Description
                orderDetailRow(title: "Deskripsi", value: viewModel.order.description)
                
                // Payment Method
                orderDetailRow(title: "Metode Pembayaran", value: viewModel.order.paymentMethod)
                
                // Pickup Address
                orderDetailRow(title: "Alamat Pengiriman/Penjemputan", value: viewModel.order.pickupAddress)
                
                // Order Details
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("No. Pesanan")
                            .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                            .foregroundColor(.black)
                        Spacer()
                        Text(viewModel.order.orderNumber)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Waktu Pembayaran")
                            .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                            .foregroundColor(.black)
                        Spacer()
                        Text(viewModel.formattedPaymentTime)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Waktu Konfirmasi Pesanan")
                            .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                            .foregroundColor(.black)
                        Spacer()
                        Text(viewModel.formattedConfirmationTime)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                }
                
                // Total Amount
                HStack {
                    Text("Total Pesanan")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    Spacer()
                    Text(viewModel.formattedTotalAmount)
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                        .foregroundColor(.black)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
    
    private func orderDetailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                .foregroundColor(.black)
            Text(value)
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    OrderDetailView()
}
