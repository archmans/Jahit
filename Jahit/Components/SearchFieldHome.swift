//
//  SearchField.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 18/05/25.
//

import SwiftUI

struct SearchFieldHome: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack (alignment: .top) {
            HeaderBackground()
            
            HStack(spacing: 12) {
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                    TextField("Cari penjahit", text: $searchText)
                        .font(.custom("PlusJakartaSans-Regular", size: 12).weight(.semibold))
                        .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                }
                .padding(.vertical, 6)
                .padding(.leading, 8)
                .padding(.trailing, 12)
                .background(Color.white)
                .cornerRadius(12)
                
                Button(action: {
                    print("Cart tapped")
                }) {
                    Image(systemName: "cart")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
        }
        .frame(height: 70)
//        Spacer()
    }
}


#Preview {
    SearchFieldHome(searchText: .constant("Cari Penjahit"))
}
