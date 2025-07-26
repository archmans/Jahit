//
//  CustomizationView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI

struct CustomizationView: View {
    @StateObject private var viewModel: CustomizationViewModel
    @StateObject private var tabBarVM = TabBarViewModel.shared
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    @State private var isCartViewPresented = false
    @FocusState private var isDescriptionFocused: Bool
    
    let tailor: Tailor
    let service: TailorService
    
    init(tailor: Tailor, service: TailorService, preSelectedProduct: ProductSearchResult? = nil) {
        self.tailor = tailor
        self.service = service
        self._viewModel = StateObject(wrappedValue: CustomizationViewModel(tailor: tailor, service: service, preSelectedProduct: preSelectedProduct))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Tailor Name
                    tailorNameView
                    
                    Divider()
                    
                    // Category
                    categoryView
                    
                    // Item Selection
                    itemSelectionView
                    
                    // Selected Item Card
                    if viewModel.customizationOrder.selectedItem != nil {
                        selectedItemCardView
                        
                        // Fabric Selection
                        fabricSelectionView
                    }
                    
                    // Description
                    descriptionView
                    
                    // Reference Images
                    referenceImagesView
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .overlay(
            VStack {
                Spacer()
                bottomSectionView
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        )
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(
                selectedImages: $viewModel.selectedImages,
                maxSelection: 10 - viewModel.customizationOrder.referenceImages.count
            )
            .presentationBackground(Color.white)
        }
        .sheet(isPresented: $viewModel.showingItemPicker) {
            ItemPickerView(viewModel: viewModel)
        }
        .onChange(of: viewModel.selectedImages) { _, newImages in
            if !newImages.isEmpty {
                viewModel.uploadImages(newImages)
            }
        }
        .navigationDestination(isPresented: $viewModel.showingOrdering) {
            OrderingView(customizationOrder: viewModel.customizationOrder)
        }
        .navigationDestination(isPresented: $isCartViewPresented) {
            CartView()
        }
        .alert("Berhasil ditambahkan!", isPresented: $viewModel.showingCartSuccess) {
            Button("OK") { }
        } message: {
            Text("Item berhasil ditambahkan ke keranjang")
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isDescriptionFocused = false
        }
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
            // Update location each time CustomizationView appears
            userManager.forceUpdateLocation()
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
            
            Text("Kustomisasi pesanan")
                .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                .foregroundColor(.black)
            
            Spacer()
            
            // Cart Button
            Button(action: {
                isCartViewPresented = true
            }) {
                ZStack {
                    Image(systemName: "cart")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .medium))
                    
                    if userManager.currentUser.totalCartItems > 0 {
                        Text("\(userManager.currentUser.totalCartItems)")
                            .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.bold))
                            .foregroundColor(.white)
                            .frame(minWidth: 20, minHeight: 20)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 12, y: -10)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var tailorNameView: some View {
        HStack(spacing: 12) {
            Image("shop")
            Text(viewModel.customizationOrder.tailorName)
                .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                .foregroundColor(.black)
        }
    }
    
    private var categoryView: some View {
        HStack(spacing: 4) {
            Text(viewModel.customizationOrder.category)
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.black)
            
            Text("*")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.red)
        }
    }
    
    private var itemSelectionView: some View {
        Button(action: {
            viewModel.showingItemPicker = true
        }) {
            HStack {
                Text(viewModel.selectedItemName)
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
    
    private var fabricSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Only show fabric selection for non-repair services
            if !viewModel.customizationOrder.isRepairService {
                // Fabric Provider Selection
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 4) {
                        Text("Pilihan Bahan")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                            .foregroundColor(.black)
                        
                        Text("*")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                            .foregroundColor(.red)
                    }
                    
                    VStack(spacing: 0) {
                        ForEach(Array(FabricProvider.allCases.enumerated()), id: \.element) { index, provider in
                            Button(action: {
                                viewModel.updateFabricProvider(provider)
                            }) {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(provider.rawValue)
                                            .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                                            .foregroundColor(.black)
                                        
                                        if provider == .personal {
                                            Text("Gratis - Gunakan bahan sendiri")
                                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                                .foregroundColor(.gray)
                                        } else {
                                            Text("Tambahan biaya sesuai jenis bahan")
                                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if provider == .personal {
                                        Text("GRATIS")
                                            .font(.custom("PlusJakartaSans-Regular", size: 10).weight(.bold))
                                            .foregroundColor(.green)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.green.opacity(0.1))
                                            .cornerRadius(4)
                                    }
                                    
                                    Image(systemName: viewModel.customizationOrder.fabricProvider == provider ? "largecircle.fill.circle" : "circle")
                                        .foregroundColor(viewModel.customizationOrder.fabricProvider == provider ? Color(red: 0, green: 0.37, blue: 0.92) : .gray)
                                        .font(.system(size: 20))
                                }
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if index < FabricProvider.allCases.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                
                // Fabric Type Selection (only when tailor provides fabric and item is selected)
                if viewModel.customizationOrder.fabricProvider == .tailor,
                   let selectedItem = viewModel.customizationOrder.selectedItem,
                   !selectedItem.availableFabrics.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            Text("Jenis Bahan")
                                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                                .foregroundColor(.black)
                            
                            Text("*")
                                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                                .foregroundColor(.red)
                        }
                        
                        VStack(spacing: 0) {
                            ForEach(Array(selectedItem.availableFabrics.enumerated()), id: \.element.id) { index, fabricOption in
                                Button(action: {
                                    viewModel.updateFabricOption(fabricOption)
                                }) {
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(fabricOption.type)
                                                .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                                                .foregroundColor(.black)
                                            
                                            Text(fabricOption.description)
                                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("+ \(NumberFormatter.currencyFormatter.string(from: NSNumber(value: fabricOption.additionalPrice)) ?? "Rp0")")
                                            .font(.custom("PlusJakartaSans-Regular", size: 10).weight(.bold))
                                            .foregroundColor(.orange)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.orange.opacity(0.1))
                                            .cornerRadius(4)
                                        
                                        Image(systemName: viewModel.customizationOrder.selectedFabricOption?.id == fabricOption.id ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(viewModel.customizationOrder.selectedFabricOption?.id == fabricOption.id ? Color(red: 0, green: 0.37, blue: 0.92) : .gray)
                                            .font(.system(size: 20))
                                    }
                                    .padding(.vertical, 8)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if index < selectedItem.availableFabrics.count - 1 {
                                    Divider()
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
            }
            
            // Price Breakdown
            priceBreakdownView
        }
        .padding(.vertical, 8)
    }
    
    private var priceBreakdownView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rincian Harga")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.black)
            
            VStack(spacing: 4) {
                HStack {
                    Text("\(viewModel.customizationOrder.selectedItem?.name ?? "") × \(viewModel.customizationOrder.quantity)")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(viewModel.formattedBasePrice)
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.gray)
                }
                
                // Only show fabric costs for non-repair services
                if !viewModel.customizationOrder.isRepairService &&
                   viewModel.customizationOrder.fabricProvider == .tailor,
                   let fabricOption = viewModel.customizationOrder.selectedFabricOption {
                    HStack {
                        Text("Biaya bahan (\(fabricOption.type))")
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.formattedFabricPrice)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Text(viewModel.formattedPrice)
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                        .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Deskripsi Pesanan (Opsional)")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.black)
            
            TextField("Deskripsikan pesanan Anda", text: Binding(
                get: { viewModel.customizationOrder.description },
                set: { viewModel.updateDescription($0) }
            ), axis: .vertical)
            .textFieldStyle(PlainTextFieldStyle())
            .foregroundColor(.black)
            .accentColor(Color(red: 0, green: 0.37, blue: 0.92))
            .focused($isDescriptionFocused)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Simpan Deskripsi") {
                        isDescriptionFocused = false
                    }
                    .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .environment(\.colorScheme, .light)
        }
    }
    
    private var referenceImagesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Referensi Gambar (Maks 10)")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                if viewModel.isUploadingImages {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            if viewModel.customizationOrder.referenceImages.isEmpty {
                Button(action: {
                    viewModel.showingImagePicker = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.up")
                            .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                            .font(.system(size: 24))
                        
                        Text(viewModel.isUploadingImages ? "Mengunggah..." : "Unggah Referensi Gambar")
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 0, green: 0.37, blue: 0.92), style: StrokeStyle(lineWidth: 2, dash: [5]))
                    )
                }
                .disabled(viewModel.isUploadingImages)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(Array(viewModel.customizationOrder.referenceImages.enumerated()), id: \.offset) { index, imageName in
                        ZStack(alignment: .topTrailing) {
                            // Try to load saved image first, fallback to bundled image
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
                            .frame(height: 80)
                            .clipped()
                            .cornerRadius(8)
                            
                            Button(action: {
                                viewModel.removeReferenceImage(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .font(.system(size: 20))
                            }
                            .offset(x: 8, y: -8)
                        }
                    }
                    
                    if viewModel.customizationOrder.referenceImages.count < 10 {
                        Button(action: {
                            viewModel.showingImagePicker = true
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "plus")
                                    .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                                    .font(.system(size: 20))
                                
                                if viewModel.isUploadingImages {
                                    ProgressView()
                                        .scaleEffect(0.6)
                                }
                            }
                            .frame(width: 110, height: 80)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 0, green: 0.37, blue: 0.92), style: StrokeStyle(lineWidth: 2, dash: [5]))
                            )
                        }
                        .disabled(viewModel.isUploadingImages)
                    }
                }
            }
        }
    }
    
    private var selectedItemCardView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                // Item Image
                if let product = viewModel.customizationOrder.selectedItem {
                    Image(product.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(8)
                    
                    // Item Details
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                            .foregroundColor(.black)
                            .lineLimit(2)
                        
                        Text("Harga jasa: \(NumberFormatter.currencyFormatter.string(from: NSNumber(value: product.price)) ?? "Rp0")")
                            .font(.custom("PlusJakartaSans-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Quantity Selection in bottom right
                    VStack(spacing: 8) {
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Button(action: {
                                viewModel.updateQuantity(viewModel.customizationOrder.quantity - 1)
                            }) {
                                Image(systemName: "minus")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .frame(width: 30, height: 30)
                                    .background(Color.white)
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .disabled(viewModel.customizationOrder.quantity <= 1)
                            
                            Text("\(viewModel.customizationOrder.quantity)")
                                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                                .foregroundColor(.black)
                                .frame(minWidth: 25)
                            
                            Button(action: {
                                viewModel.updateQuantity(viewModel.customizationOrder.quantity + 1)
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .frame(width: 30, height: 30)
                                    .background(Color.white)
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
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var bottomSectionView: some View {
        HStack(spacing: 16) {
            Button(action: {
                viewModel.addToCart()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .foregroundColor(viewModel.customizationOrder.selectedItem != nil ? Color(red: 0, green: 0.37, blue: 0.92) : .gray)
                        .font(.system(size: 16))
                    
                    Image(systemName: "cart")
                        .foregroundColor(viewModel.customizationOrder.selectedItem != nil ? Color(red: 0, green: 0.37, blue: 0.92) : .gray)
                        .font(.system(size: 16))
                }
                .padding(16)
                .background((viewModel.customizationOrder.selectedItem != nil ? Color(red: 0, green: 0.37, blue: 0.92) : Color.gray).opacity(0.1))
                .cornerRadius(8)
            }
            .disabled(viewModel.customizationOrder.selectedItem == nil)
            
            Button(action: {
                viewModel.proceedToOrder()
            }) {
                Text("Pembayaran")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(viewModel.customizationOrder.isValid ? Color(red: 0, green: 0.37, blue: 0.92) : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.customizationOrder.isValid)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

#Preview {
    let sampleTailor = Tailor.sampleTailors.first!
    let sampleService = sampleTailor.services.first!
    return CustomizationView(tailor: sampleTailor, service: sampleService)
}
