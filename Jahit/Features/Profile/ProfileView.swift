//
//  ProfileView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/06/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showLogoutAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Akun Saya")
                    .font(.custom("PlusJakartaSans-Regular", size: 24).weight(.bold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Profile content
            VStack(spacing: 20) {
                // User Info Card
                HStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(userManager.currentUser.name)
                            .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.semibold))
                            .foregroundColor(.black)
                        
                        if let email = userManager.currentUser.email {
                            Text(email)
                                .font(.custom("PlusJakartaSans-Regular", size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        if let phone = userManager.currentUser.phoneNumber {
                            Text(phone)
                                .font(.custom("PlusJakartaSans-Regular", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(16)
                
                // Account Settings
                VStack(spacing: 12) {

                    VStack {
                        ProfileMenuItem(
                            icon: "person.fill",
                            title: "Manajemen Akun",
                            action: {
                                // TODO: Navigate to edit profile
                            }
                        )
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)

                    VStack {
                        ProfileMenuItem(
                            icon: "globe",
                            title: "Pilih Bahasa",
                            action: {
                            }
                        )
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)

                    VStack {
                        ProfileMenuItem(
                            icon: "shield.fill",
                            title: "Kebijakan Privasi",
                            action: {
                            }
                        )
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    VStack {
                        ProfileMenuItem(
                            icon: "questionmark.circle.fill",
                            title: "Bantuan",
                            action: {
                                // TODO: Navigate to help
                            }
                        )
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                }
                
                // Logout Button
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                            .font(.system(size: 18))
                        
                        Text("Keluar")
                            .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                            .foregroundColor(.red)
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .navigationBarHidden(true)
        .alert("Keluar", isPresented: $showLogoutAlert) {
            Button("Batal", role: .cancel) { }
            Button("Keluar", role: .destructive) {
                userManager.logout()
            }
        } message: {
            Text("Apakah Anda yakin ingin keluar?")
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    init(icon: String, title: String, subtitle: String? = nil, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 18))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                        .foregroundColor(.black)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.custom("PlusJakartaSans-Regular", size: 12))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserManager.shared)
}
