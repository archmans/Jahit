//
//  TimeSelectionComponent.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/07/25.
//

import SwiftUI

struct TimeSelectionComponent: View {
    @Binding var selectedTime: TimeSlot?
    @Binding var showingTimePicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("Pilih Jam Jemput")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                Text("*")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.red)
            }
            
            Button(action: {
                showingTimePicker = true
            }) {
                HStack {
                    Text(selectedTime?.displayName ?? "Belum dipilih")
                        .font(.custom("PlusJakartaSans-Regular", size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0, green: 0.37, blue: 0.92))
                .cornerRadius(15)
            }
        }
    }
}

#Preview {
    TimeSelectionComponent(
        selectedTime: .constant(nil),
        showingTimePicker: .constant(false)
    )
}
