//
//  DateSelectionComponent.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/07/25.
//

import SwiftUI

struct DateSelectionComponent: View {
    @Binding var selectedDate: Date?
    @Binding var showingDatePicker: Bool
    
    var formattedDate: String {
        guard let selectedDate = selectedDate else {
            return "Belum dipilih"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("Pilih Tanggal Jemput")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                Text("*")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.bold))
                    .foregroundColor(.red)
            }
            
            Button(action: {
                showingDatePicker = true
            }) {
                HStack {
                    Text(formattedDate)
                        .font(.custom("PlusJakartaSans-Regular", size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
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
    DateSelectionComponent(
        selectedDate: .constant(nil),
        showingDatePicker: .constant(false)
    )
}
