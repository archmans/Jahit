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
    @Environment(\.dismiss) private var dismiss
    
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
                    
                    // Description
                    descriptionView
                    
                    // Reference Images
                    referenceImagesView
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            bottomSectionView
        }
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(
                selectedImages: $viewModel.selectedImages,
                maxSelection: 10 - viewModel.customizationOrder.referenceImages.count
            )
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
        .alert("Berhasil ditambahkan!", isPresented: $viewModel.showingCartSuccess) {
            Button("OK") { }
        } message: {
            Text("Item berhasil ditambahkan ke keranjang")
        }
        .navigationBarHidden(true)
        .onAppear {
            tabBarVM.hide()
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
        Text(viewModel.customizationOrder.category)
            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
            .foregroundColor(.black)
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
            .background(Color.blue)
            .cornerRadius(15)
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Deskripsi Pesanan (optional)")
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.black)
            
            TextField("Deskripsikan pesanan Anda secara detail", text: Binding(
                get: { viewModel.customizationOrder.description },
                set: { viewModel.updateDescription($0) }
            ), axis: .vertical)
            .textFieldStyle(PlainTextFieldStyle())
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
    
    private var referenceImagesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Gambar atau Referensi (Max 10)")
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
                            .foregroundColor(.blue)
                            .font(.system(size: 24))
                        
                        Text(viewModel.isUploadingImages ? "Uploading..." : "Upload Image")
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                    )
                }
                .disabled(viewModel.isUploadingImages)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
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
                            .frame(width: 90, height: 90)
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
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                                
                                if viewModel.isUploadingImages {
                                    ProgressView()
                                        .scaleEffect(0.6)
                                }
                            }
                            .frame(width: 90, height: 90)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                            )
                        }
                        .disabled(viewModel.isUploadingImages)
                    }
                }
            }
        }
    }
    
    private var bottomSectionView: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Button(action: {
                    viewModel.addToCart()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                    
                    Image(systemName: "cart")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                }
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Jumlah Pembelian")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.gray)
                
                HStack(spacing: 8) {
                    Button(action: {
                        viewModel.updateQuantity(viewModel.customizationOrder.quantity - 1)
                    }) {
                        Image(systemName: "minus")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .disabled(viewModel.customizationOrder.quantity <= 1)
                    
                    Text("\(viewModel.customizationOrder.quantity)")
                        .font(.custom("PlusJakartaSans-Regular", size: 16))
                        .foregroundColor(.black)
                        .frame(minWidth: 20)
                    
                    Button(action: {
                        viewModel.updateQuantity(viewModel.customizationOrder.quantity + 1)
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.proceedToOrder()
            }) {
                Text("Pesan")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(viewModel.customizationOrder.isValid ? Color.blue : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.customizationOrder.isValid)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

#Preview {
    let sampleTailor = Tailor.sampleTailors.first!
    let sampleService = sampleTailor.services.first!
    return CustomizationView(tailor: sampleTailor, service: sampleService)
}
