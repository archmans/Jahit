//
//  ItemPickerView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 14/06/25.
//

import SwiftUI

struct ItemPickerView: View {
    @ObservedObject var viewModel: CustomizationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 4)
                
                HStack {
                    Text("Pilih Item")
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
            
            // Items List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.availableItems) { item in
                        Button(action: {
                            viewModel.selectItem(item)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                                        .foregroundColor(.black)
                                    
                                    Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.price)) ?? "")
                                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                if viewModel.customizationOrder.selectedItem?.id == item.id {
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
        .presentationDetents([.fraction(0.6)])
        .presentationDragIndicator(.hidden)
    }
}
