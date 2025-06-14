//
//  TimePickerView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: TimeSlot
    let onTimeSelected: (TimeSlot) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 4)
                
                HStack {
                    Text("Pilih Jam")
                        .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Tutup") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            
            // Time Slots
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(TimeSlot.allCases, id: \.self) { timeSlot in
                        Button(action: {
                            selectedTime = timeSlot
                            onTimeSelected(timeSlot)
                        }) {
                            HStack {
                                Text(timeSlot.displayName)
                                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                if selectedTime == timeSlot {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                            .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.top, 16)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.hidden)
    }
}
