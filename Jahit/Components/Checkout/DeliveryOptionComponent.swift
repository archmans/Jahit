//
//  DeliveryOptionComponent.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/07/25.
//

import SwiftUI

struct DeliveryOptionComponent: View {
    @Binding var selectedDeliveryOption: DeliveryOption?
    let tailorLocationDescription: String?
    let onSelectionChanged: (DeliveryOption) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Pesanan diantar")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                Text("*")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 0) {
                ForEach(DeliveryOption.allCases, id: \.self) { option in
                    Button(action: {
                        selectedDeliveryOption = option
                        onSelectionChanged(option)
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: option == .delivery ? "truck.box" : "bag")
                                .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                                .font(.system(size: 20))
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(option.description)
                                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                                    .foregroundColor(.black)
                                
                                if let subtitle = option.subtitle {
                                    Text(subtitle)
                                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                                        .foregroundColor(.gray)
                                } else if option == .pickup {
                                    Text(tailorLocationDescription ?? "Lokasi tidak tersedia")
                                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                            }
                            
                            Spacer()
                            
                            if option.additionalCost > 0 {
                                Text("+\(NumberFormatter.currencyFormatter.string(from: NSNumber(value: option.additionalCost)) ?? "Rp15.000")")
                                    .font(.custom("PlusJakartaSans-Regular", size: 10).weight(.bold))
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(4)
                            }
                            
                            Image(systemName: selectedDeliveryOption == option ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(selectedDeliveryOption == option ? Color(red: 0, green: 0.37, blue: 0.92) : .gray)
                                .font(.system(size: 20))
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if option != DeliveryOption.allCases.last {
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
    DeliveryOptionComponent(
        selectedDeliveryOption: .constant(.delivery),
        tailorLocationDescription: "Jl. Contoh No. 123, Jakarta",
        onSelectionChanged: { _ in }
    )
}
