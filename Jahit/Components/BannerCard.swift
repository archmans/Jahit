//
//  BannerCard.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/05/25.
//

import SwiftUI

struct BannerCard: View {
    @State private var currentIndex = 0
    @State private var timer: Timer?

    private let bannerImages = ["banner", "banner", "banner"]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(0..<bannerImages.count, id: \.self) { index in
                    Image(bannerImages[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(12)
                        .tag(index)
                        .padding(.horizontal, 2)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 120)
            .onAppear {
                startAutoScroll()
            }
            .onDisappear {
                stopAutoScroll()
            }
            
            HStack(spacing: 8) {
                ForEach(0..<bannerImages.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color(red: 0, green: 0.37, blue: 0.92) : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentIndex == index ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.7), value: currentIndex)
                }
            }
            .padding(.top, 12)
        }
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % bannerImages.count
            }
        }
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    BannerCard()
}
