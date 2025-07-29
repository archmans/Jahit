//
//  TransactionDetailView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 12/06/25.
//

import SwiftUI

struct OrderDetailView: View {
    @StateObject private var viewModel: OrderDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(order: Order? = nil) {
        self._viewModel = StateObject(wrappedValue: OrderDetailViewModel(order: order ?? Order.sampleOrder))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    progressStepsView
                    
                    orderContentView
                }
            }
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .navigationBarHidden(true)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 && abs(value.translation.height) < 50 {
                        TabBarViewModel.shared.show()
                        dismiss()
                    }
                }
        )
        .onDisappear {
            TabBarViewModel.shared.show()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                TabBarViewModel.shared.show()
                dismiss()
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
        VStack(spacing: 4) {
            ForEach(Array(viewModel.applicableStatuses.enumerated()), id: \.offset) { index, status in
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(index <= viewModel.currentStepIndex ? Color(red: 0, green: 0.37, blue: 0.92) : Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                            
                            Image(status.icon)
                                .foregroundColor(index <= viewModel.currentStepIndex ? .white : .gray)
                                .font(.system(size: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(status.rawValue)
                                .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                                .foregroundColor(index <= viewModel.currentStepIndex ? .blue : .gray)
                        }
                        
                        Spacer()
                        
                        if index <= viewModel.currentStepIndex {
                            Text(getTimeForStatus(index: index))
                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if index < viewModel.applicableStatuses.count - 1 {
                        HStack {
                            VStack(spacing: 2) {
                                ForEach(0..<6, id: \.self) { _ in
                                    Circle()
                                        .fill(index < viewModel.currentStepIndex ? Color(red: 0, green: 0.37, blue: 0.92) : Color.gray.opacity(0.3))
                                        .frame(width: 3, height: 3)
                                }
                            }
                            .frame(width: 40, height: 24)
                            
                            Spacer()
                        }
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
                .background(Color(red: 0, green: 0.37, blue: 0.92).opacity(0.7))
                .cornerRadius(12)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    itemsListView
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    orderDetailRow(title: "Alamat Pengiriman/Penjemputan", value: viewModel.order.pickupAddress)
                    
                    orderDetailRow(title: "Metode Pembayaran", value: viewModel.order.paymentMethod)
                    
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
                    }
                    
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
                    
                    if let review = viewModel.orderReview {
                        VStack(alignment: .leading, spacing: 8) {
                            Divider()
                                .padding(.vertical, 8)
                            
                            ReviewCardView(review: review)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var itemsListView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Item Pesanan")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                .foregroundColor(.black)
            
            ForEach(viewModel.transactionItems, id: \.id) { item in
                TransactionItemRowView(item: item, isLast: item.id == viewModel.transactionItems.last?.id)
            }
            
            if let deliveryOption = viewModel.order.deliveryOption {
                VStack(spacing: 8) {
                    Divider()
                        .padding(.vertical, 4)
                    
                    HStack {
                        Text(deliveryOption == .delivery ? "Ongkos kirim" : "Ambil sendiri")
                            .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                            .foregroundColor(.black)
                        Spacer()
                        Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: viewModel.order.deliveryCost)) ?? "Rp0")
                            .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                    }
                }
            }
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
    
    private func getTimeForStatus(index: Int) -> String {
        switch index {
        case 0:
            return viewModel.formattedPaymentTime
        case 1:
            return viewModel.formattedConfirmationTime
        default:
            return viewModel.formattedConfirmationTime
        }
    }
}

struct TransactionItemRowView: View {
    let item: TransactionItem
    let isLast: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            itemHeaderView
            
            if let description = item.customDescription, !description.isEmpty {
                itemDescriptionView(description: description)
            }
            
            if !item.referenceImages.isEmpty {
                itemImagesView
            }
            
            if !isLast {
                Divider()
                    .padding(.vertical, 4)
            }
        }
    }
    
    private var itemHeaderView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                        .foregroundColor(.black)
                    
                    Text("Kuantitas: \(item.quantity)")
                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.totalPrice)) ?? "Rp0")
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                    
                    if item.fabricPrice > 0 {
                        Text("(termasuk bahan)")
                            .font(.custom("PlusJakartaSans-Regular", size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if let fabricProvider = item.fabricProvider {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if fabricProvider == .personal {
                            Text("Bahan pribadi")
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
        }
    }
    
    private func itemDescriptionView(description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Deskripsi:")
                .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.medium))
                .foregroundColor(.gray)
            
            Text(description)
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundColor(.black)
        }
    }
    
    private var itemImagesView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Referensi Gambar (\(item.referenceImages.count)):")
                .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.medium))
                .foregroundColor(.gray)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(item.referenceImages, id: \.self) { imageName in
                    ItemImageView(imageName: imageName)
                }
            }
        }
    }
}

struct ItemImageView: View {
    let imageName: String
    
    var body: some View {
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
        .frame(width: 60, height: 60)
        .clipped()
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    OrderDetailView()
}
