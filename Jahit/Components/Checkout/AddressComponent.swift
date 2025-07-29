//
//  AddressComponent.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/07/25.
//

import SwiftUI

struct AddressComponent: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var showingAddressSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 2) {
                    Text("Alamat")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                        .foregroundColor(.black)
                    
                    Text("*")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button(action: {
                    showingAddressSheet = true
                }) {
                    Text("Ubah Alamat")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(userManager.currentUser.name.isEmpty ? "Nama belum diset" : userManager.currentUser.name)
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                        .foregroundColor(userManager.currentUser.name.isEmpty ? .gray : .black)
                    
                    Text("-")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.gray)
                    
                    Text(userManager.currentUser.phoneNumber?.isEmpty != false ? "Nomor handphone belum diset" : userManager.currentUser.phoneNumber!)
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(userManager.currentUser.phoneNumber?.isEmpty != false ? .gray : .black)
                }
                
                HStack(spacing: 8) {
                    Image("location")
                        .foregroundColor(.red)
                    
                    if userManager.isLocationLoading {
                        Text("Mendapatkan alamat...")
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                    } else if let address = userManager.currentUser.address, !address.isEmpty {
                        Text(address)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.black)
                    } else {
                        Text("Alamat belum diset")
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    AddressComponent(showingAddressSheet: .constant(false))
        .environmentObject(UserManager.shared)
}
