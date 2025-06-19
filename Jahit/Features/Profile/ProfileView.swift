//
//  ProfileView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/06/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var tabBarVM = TabBarViewModel.shared
    
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
            
            // Profile content placeholder
            VStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                
                Text("Profil User")
                    .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.semibold))
                    .foregroundColor(.black)
                
                Text("Fitur profil akan segera hadir")
                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(32)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarHidden(true)
        .onAppear {
            tabBarVM.show()
        }
    }
}

#Preview {
    ProfileView()
}
