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
    @State private var showPriceConfirmation = false
    @State private var showRejectAlert = false
    @State private var proposedFinalPrice: String = ""
    
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
                    
                    if viewModel.order.status == .cancelled {
                        orderCancelledSection
                    }
                    
                    if viewModel.order.status == .pickup && !viewModel.order.isPriceConfirmed {
                        priceConfirmationSection
                    }
                }
            }
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .navigationBarHidden(true)
        .sheet(isPresented: $showPriceConfirmation) {
            priceConfirmationSheet
        }
        .alert("Tolak Harga", isPresented: $showRejectAlert) {
            Button("Batal", role: .cancel) { }
            Button("Ya, Tolak", role: .destructive) {
                viewModel.rejectPrice()
            }
        } message: {
            Text("Apakah Anda yakin ingin menolak harga ini? Pesanan akan dibatalkan dan tidak dapat dikembalikan.")
        }
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
                    
                    if !shouldShowFixedPrice {
                        HStack {
                            Text("Estimasi Total")
                                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                                .foregroundColor(.black)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(viewModel.formattedTotalAmount)
                                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    if shouldShowFixedPrice {
                        fixedPriceSection
                    }
                    
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
    
    private var priceConfirmationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Penjahit telah menyelesaikan pengukuran dan menetapkan harga final untuk pesanan Anda.")
                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Harga Final:")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Text(viewModel.formattedProposedFinalPrice)
                        .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                        .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                }
                
                HStack(spacing: 12) {
                    Button(action: {
                        showRejectAlert = true
                    }) {
                        Text("Tolak")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        showPriceConfirmation = true
                    }) {
                        Text("Terima")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(red: 0, green: 0.37, blue: 0.92))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .padding(.top, 20)
    }
    
    private var orderCancelledSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                    
                    Text("Pesanan Dibatalkan")
                        .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                        .foregroundColor(.red)
                }
                
                Text("Pesanan ini telah dibatalkan karena harga yang diajukan tidak dapat diterima. Tidak ada biaya yang dikenakan untuk pesanan yang dibatalkan.")
                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                    .foregroundColor(.gray)
                
                Text("Jika Anda memiliki pertanyaan, silakan hubungi penjahit atau layanan pelanggan.")
                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 20)
            .background(Color.red.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
    }
    
    private var priceConfirmationSheet: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Konfirmasi Harga")
                        .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                        .foregroundColor(.black)
                    
                    Text("Dengan menerima harga ini, Anda setuju untuk melanjutkan pesanan dengan harga final yang telah ditetapkan.")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Detail Harga:")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.black)
                    
                    HStack {
                        Text("Estimasi Sebelumnya:")
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.formattedTotalAmount)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Harga Final:")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(viewModel.formattedProposedFinalPrice)
                            .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                            .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                    }
                }
                .padding(.all, 16)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.confirmPrice(viewModel.proposedFinalPrice)
                        showPriceConfirmation = false
                    }) {
                        Text("Konfirmasi & Lanjutkan")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0, green: 0.37, blue: 0.92))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        showPriceConfirmation = false
                    }) {
                        Text("Batal")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .background(Color.white)
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
    }
    
    private var shouldShowFixedPrice: Bool {
        return viewModel.order.isPriceConfirmed && 
                viewModel.order.finalPrice != nil &&
                (viewModel.order.status == .pickup || 
                viewModel.order.status == .inProgress || 
                viewModel.order.status == .readyForPickup || 
                viewModel.order.status == .onDelivery || 
                viewModel.order.status == .completed)
    }
    
    private var fixedPriceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
                .padding(.vertical, 8)
            
            HStack {
                Text("Harga Final")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    if let finalPrice = viewModel.order.finalPrice {
                        let totalWithDelivery = finalPrice + viewModel.order.deliveryCost
                        let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: totalWithDelivery)) ?? "Rp0"
                        Text(formattedPrice)
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.top, 8)
            
            Text("Harga telah dikonfirmasi dan tidak akan berubah")
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundColor(.gray)
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
                    Text(item.priceEstimate.formattedRange)
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                    
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