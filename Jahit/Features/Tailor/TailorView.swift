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
    @Environment(\.dismiss) private var dismiss
    
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
            .background(Color(UIColor.systemGroupedBackground))
        }
        .navigationBarHidden(true)
        .onAppear {
            tabBarVM.hide()
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
            
            HStack(spacing: 8) {
                ForEach(indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
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
    
    func reviewItemView(review: Review) -> some View {
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
            
            if let userImage = review.userImage {
                Image(userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
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
}

#Preview {
    TailorDetailView(tailor: Tailor.sampleTailors.first!)
}
