//
//  LocationLabel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/05/25.
//

import SwiftUI

struct LocationLabel: View {
    @StateObject private var viewModel = LocationViewModel()
    var body: some View {
        HStack(spacing: 8) {
            Image("location")
                .foregroundColor(.red)
            Text(viewModel.formattedAddress ?? "Mendapatkan alamat...")
                .font(.custom("PlusJakartaSans-Regular", size: 12))
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

#Preview {
    LocationLabel()
}
