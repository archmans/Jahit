//
//  AuthenticationWrapper.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/06/25.
//

import SwiftUI

struct AuthenticationWrapper: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showAuthenticationView = false
    
    var body: some View {
        Group {
            if userManager.currentUser.isLoggedIn {
                TabBarView()
                    .onAppear {
                        showAuthenticationView = false
                    }
            } else {
                // Authentication required
                VStack(spacing: 20) {
                    Image("JahitLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                    
                    VStack(spacing: 8) {
                        Text("Selamat Datang di Jahit")
                            .font(.custom("PlusJakartaSans-Regular", size: 24).weight(.bold))
                            .foregroundColor(.black)
                        
                        Text("Silakan masuk atau daftar untuk melanjutkan")
                            .font(.custom("PlusJakartaSans-Regular", size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        showAuthenticationView = true
                    }) {
                        Text("Mulai")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
        }
        .fullScreenCover(isPresented: $showAuthenticationView) {
            LoginView()
        }
        .onChange(of: userManager.currentUser.isLoggedIn) { _, isLoggedIn in
            if isLoggedIn {
                showAuthenticationView = false
            }
        }
    }
}

#Preview {
    AuthenticationWrapper()
        .environmentObject(UserManager.shared)
}
