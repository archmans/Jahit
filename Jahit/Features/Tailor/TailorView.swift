//
//  TailorView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI

struct TailorDetailView: View {
    @StateObject private var viewModel: TailorViewModel
    @StateObject private var tabBarVM = TabBarViewModel.shared
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    @State private var isCartViewPresented = false
    @State private var autoScrollTimers: [String: Timer] = [:]
    
    init(tailor: Tailor) {
        _viewModel = StateObject(wrappedValue: TailorViewModel(tailor: tailor))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                    tabBarVM.show()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: 24, weight: .medium))
                }
                
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
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerView
                    tabNavigationView
                    tabContentView
                }
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        }
        .background(Color.white)
        .navigationDestination(isPresented: $isCartViewPresented) {
            CartView()
        }
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
                        tabBarVM.show()
                    }
                }
        )
        .onAppear {
            tabBarVM.hide()
        }
        .onDisappear {
            stopAllAutoScroll()
        }
    }
    
    var headerView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(viewModel.tailor.profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.tailor.name)
                        .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 4) {
                        Image("location")
                            .foregroundColor(.red)
                            .font(.system(size: 12))
                        
                        Text(viewModel.tailor.location)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        
                        Text(viewModel.formattedRating)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                Button(action: {
                    viewModel.contactViaWhatsApp()
                }) {
                    Image("whatsapp")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(8)
                        .background(Color.green)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 14)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .padding(.bottom, 20)
        .background(Color.white)
    }
    
    var tabNavigationView: some View {
        HStack(spacing: 0) {
            ForEach(TailorTab.allCases, id: \.self) { tab in
                Button(action: {
                    viewModel.selectTab(tab)
                }) {
                    VStack(spacing: 8) {
                        Text(tab.rawValue)
                            .font(.custom("PlusJakartaSans-Regular", size: 16))
                            .foregroundColor(viewModel.selectedTab == tab ? .blue : .gray)
                        
                        Rectangle()
                            .fill(viewModel.selectedTab == tab ? Color.blue : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color.white)
    }
    
    var tabContentView: some View {
        Group {
            switch viewModel.selectedTab {
            case .services:
                servicesTabView
            case .reviews:
                reviewsTabView
            case .about:
                aboutTabView
            }
        }
        .padding(.top, 16)
    }
    
    var servicesTabView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.tailor.services, id: \.id) { service in
                NavigationLink(destination: CustomizationView(tailor: viewModel.tailor, service: service)) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(service.name)
                                    .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                                    .foregroundColor(.black)
                                
                                Text(service.description)
                                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                HStack {
                                    Text("Mulai dari")
                                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                                        .foregroundColor(.black)
                                    
                                    Text(viewModel.formattedStartingPrice(for: service))
                                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                        
                        imageCarouselView(images: service.images, serviceId: service.id)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
    }
    
    func imageCarouselView(images: [String], serviceId: String) -> some View {
        let indices = images.indices.map { $0 }
        let currentIndex = viewModel.getCurrentImageIndex(for: serviceId)
        
        return VStack(spacing: 12) {
            TabView(selection: Binding(
                get: { currentIndex },
                set: { viewModel.setCurrentImageIndex($0, for: serviceId) }
            )) {
                ForEach(indices, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                        .tag(index)
                        .padding(.horizontal, 2)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            .onAppear {
                startAutoScroll(for: serviceId)
            }
            .onDisappear {
                stopAutoScroll(for: serviceId)
            }
            
            HStack(spacing: 8) {
                ForEach(indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.7), value: currentIndex)
                        .onTapGesture {
                            viewModel.setCurrentImageIndex(index, for: serviceId)
                        }
                }
            }
        }
    }
    
    var reviewsTabView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.tailor.reviews, id: \.id) { review in
                reviewItemView(review: review)
            }
        }
        .padding(.horizontal, 16)
    }
    
    func reviewItemView(review: TailorReview) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(review.userName)
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(review.timeAgo)
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= review.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.system(size: 14))
                }
            }
            
            Text(review.comment)
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.black)
                .lineLimit(nil)
            
            // Review Images
            if !review.reviewImages.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 12) {
                    ForEach(review.reviewImages, id: \.self) { imageName in
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
                        .frame(width: 70, height: 60)
                        .clipped()
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    var aboutTabView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Description Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Deskripsi")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    
                    Text(viewModel.tailor.description)
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Lokasi")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    
                    Text(viewModel.tailor.locationDescription)
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
    }
    
    private func startAutoScroll(for serviceId: String) {
        stopAutoScroll(for: serviceId)
        
        autoScrollTimers[serviceId] = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                viewModel.nextImage(for: serviceId)
            }
        }
    }
    
    private func stopAutoScroll(for serviceId: String) {
        autoScrollTimers[serviceId]?.invalidate()
        autoScrollTimers[serviceId] = nil
    }
    
    private func stopAllAutoScroll() {
        for (_, timer) in autoScrollTimers {
            timer.invalidate()
        }
        autoScrollTimers.removeAll()
    }
}

#Preview {
    TailorDetailView(tailor: Tailor.sampleTailors.first!)
}
