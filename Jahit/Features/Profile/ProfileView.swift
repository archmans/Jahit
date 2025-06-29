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
                Text("Profil")
                    .font(.custom("PlusJakartaSans-Regular", size: 24).weight(.bold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Profile content
            VStack(spacing: 20) {
                // User Info Card
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    VStack(spacing: 8) {
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
                        
                        if let provider = userManager.currentUser.authProvider {
                            HStack(spacing: 4) {
                                Image(systemName: provider == "google" ? "globe" : provider == "apple" ? "applelogo" : "envelope")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                                
                                Text("Masuk dengan \(provider.capitalized)")
                                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(16)
                
                // Account Settings
                VStack(spacing: 12) {
                    ProfileMenuItem(
                        icon: "person.fill",
                        title: "Edit Profil",
                        action: {
                            // TODO: Navigate to edit profile
                        }
                    )
                    
                    ProfileMenuItem(
                        icon: "location.fill",
                        title: "Alamat",
                        subtitle: userManager.currentUser.address ?? "Belum diset",
                        action: {
                            // TODO: Navigate to address settings
                        }
                    )
                    
                    ProfileMenuItem(
                        icon: "bell.fill",
                        title: "Notifikasi",
                        action: {
                            // TODO: Navigate to notification settings
                        }
                    )
                    
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
        .background(Color(UIColor.systemGroupedBackground))
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
