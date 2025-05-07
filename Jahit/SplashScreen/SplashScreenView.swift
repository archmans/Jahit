//
//  SplashScreenView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 05/05/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack(alignment: .center, spacing: 7) {
                VStack {
                    Image("JahitLogo")
                    Text("Jahit")
                        .font(
                            Font.custom("PlusJakartaSans-Regular", size: 40)
                                .weight(.bold)
                        )
                        .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                    
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        size = 0.9
                        opacity = 1.0
                    }
                }
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
