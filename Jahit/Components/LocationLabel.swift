//
//  LocationLabel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/05/25.
//

import SwiftUI

struct LocationLabel: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        HStack(spacing: 8) {
            Image("location")
                .foregroundColor(.red)
            
            if userManager.isLocationLoading {
                Text("Mendapatkan alamat...")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.gray)
            } else if let address = userManager.currentUser.address {
                Text(address)
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.black)
            } else {
                Text("Lokasi tidak tersedia")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

#Preview {
    LocationLabel()
        .environmentObject(UserManager.shared)
}
