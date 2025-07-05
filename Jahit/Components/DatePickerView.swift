//
//  DatePickerView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date?
    let onDateSelected: (Date) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var internalDate: Date
    
    init(selectedDate: Binding<Date?>, onDateSelected: @escaping (Date) -> Void) {
        self._selectedDate = selectedDate
        self.onDateSelected = onDateSelected
        // Initialize with tomorrow's date or existing selected date
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        self._internalDate = State(initialValue: selectedDate.wrappedValue ?? tomorrow)
    }
    
    private var tomorrowDate: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 4)
                
                HStack {
                    Text("Pilih Tanggal")
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
            
            // Date Picker
            DatePicker("", selection: $internalDate, in: tomorrowDate..., displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .environment(\.locale, Locale(identifier: "id_ID"))
                .padding(.horizontal, 20)
            
            // Confirm Button
            Button(action: {
                onDateSelected(internalDate)
            }) {
                Text("Pilih Tanggal")
                    .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .presentationDetents([.fraction(0.7)])
        .presentationDragIndicator(.hidden)
    }
}
