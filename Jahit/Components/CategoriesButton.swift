//
//  CategoriesButton.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/05/25.
//

import SwiftUI

struct CategoriesButton: View {
    var body: some View {
        HStack(alignment: .center) {
            ForEach(["atasan", "bawahan", "terusan", "perbaikan"], id: \.self) { imageName in
                Button(action: {
                    // Action
                }) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    CategoriesButton()
}
