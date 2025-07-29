//
//  PaymentMethodComponent.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/07/25.
//

import SwiftUI

struct PaymentMethodComponent: View {
    @Binding var selectedPaymentMethod: PaymentMethod?
    let onSelectionChanged: (PaymentMethod) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Metode Pembayaran")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                Text("*")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 0) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    Button(action: {
                        selectedPaymentMethod = method
                        onSelectionChanged(method)
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: method.icon)
                                .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                                .font(.system(size: 20))
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(method.displayName)
                                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                                    .foregroundColor(.black)
                                
                                if let subtitle = method.subtitle {
                                    Text(subtitle)
                                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(selectedPaymentMethod == method ? Color(red: 0, green: 0.37, blue: 0.92) : .gray)
                                .font(.system(size: 20))
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if method != PaymentMethod.allCases.last {
                        Divider()
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

#Preview {
    PaymentMethodComponent(
        selectedPaymentMethod: .constant(.cod),
        onSelectionChanged: { _ in }
    )
}
