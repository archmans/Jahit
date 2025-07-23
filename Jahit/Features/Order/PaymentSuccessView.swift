
//
//  PaymentSuccessView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 05/07/25.
//

import SwiftUI

struct PaymentSuccessView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
            
            Text("Pembayaran Berhasil!")
                .font(.custom("PlusJakartaSans-Regular", size: 24).weight(.bold))
                .foregroundColor(.black)
            
            Text("Pesananmu akan segera diproses oleh penjahit.")
                .font(.custom("PlusJakartaSans-Regular", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                TabBarViewModel.shared.selectedTab = 1
                TabBarViewModel.shared.show()
                onDismiss()
            }) {
                Text("Riwayat Transaksi")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0, green: 0.37, blue: 0.92))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    PaymentSuccessView(onDismiss: {})
}
