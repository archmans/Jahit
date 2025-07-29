//
//  RatingPopupView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/06/25.
//

import SwiftUI
import PhotosUI

struct RatingPopupView: View {
    @Binding var isPresented: Bool
    let transaction: Transaction
    let onSubmit: (Review) -> Void
    
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var isShowingImagePicker = false
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Beri Penilaian")
                                .font(.custom("PlusJakartaSans-Regular", size: 24).weight(.bold))
                                .foregroundColor(.black)
                            
                            Text("Bagaimana pengalaman Anda dengan \(transaction.tailorName)?")
                                .font(.custom("PlusJakartaSans-Regular", size: 16))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 8)
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 2) {
                                Text("Rating")
                                    .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                                    .foregroundColor(.black)
                                
                                Text("*")
                                    .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { star in
                                    Button(action: {
                                        rating = star
                                    }) {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.system(size: 32))
                                        .foregroundColor(star <= rating ? .yellow : .gray.opacity(0.3))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Komentar")
                            .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Tulis pengalaman Anda...", text: $comment, axis: .vertical)
                            .font(.custom("PlusJakartaSans-Regular", size: 16))
                            .foregroundColor(.black)
                            .accentColor(Color(red: 0, green: 0.37, blue: 0.92))
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .lineLimit(5, reservesSpace: true)
                            .environment(\.colorScheme, .light)
                    }
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Foto")
                                .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "camera.fill")
                                    Text("Tambah Foto")
                                }
                                .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                                .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                            }
                        }
                        
                        if !selectedImages.isEmpty {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                                ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fill)
                                            .frame(height: 80)
                                            .clipped()
                                            .cornerRadius(8)
                                        
                                        Button(action: {
                                            selectedImages.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .font(.system(size: 20))
                                        }
                                        .padding(4)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            
            VStack(spacing: 0) {
                Divider()
                
                Button(action: {
                    submitReview()
                }) {
                    Text(isSubmitting ? "Mengirim..." : "Kirim")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(canSubmit ? Color(red: 0, green: 0.37, blue: 0.92) : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!canSubmit || isSubmitting)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Batal") {
                    isPresented = false
                }
                .foregroundColor(.gray)
            }
        }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImages: $selectedImages, maxSelection: 5)
                .presentationBackground(Color.white)
        }
    }
    
    private var canSubmit: Bool {
        return rating > 0
    }
    
    private func submitReview() {
        guard canSubmit else { return }
        
        isSubmitting = true
        
        let imageNames = ImageManager.shared.saveImages(selectedImages)
        
        let review = Review(
            transactionId: transaction.id,
            tailorId: transaction.tailorId,
            userId: UserManager.shared.currentUser.id,
            userName: UserManager.shared.currentUser.name,
            rating: rating,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            reviewImages: imageNames
        )
        
        onSubmit(review)
        
        isSubmitting = false
        isPresented = false
    }
}

#Preview {
    RatingPopupView(
        isPresented: .constant(true),
        transaction: Transaction(
            id: "TXN-001",
            tailorId: "1",
            tailorName: "Alfa Tailor",
            items: [],
            totalPrice: 250000,
            pickupDate: Date(),
            pickupTime: "14:00",
            paymentMethod: "GoPay",
            customerAddress: "Jl. Ganesha No. 10, Bandung",
            orderDate: Date(),
            status: .completed,
            review: nil,
            deliveryOption: .delivery,
            deliveryCost: 15000
        )
    ) { review in
        print("Review submitted: \(review)")
    }
}
