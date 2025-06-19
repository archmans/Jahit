//
//  CategoriesButton.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 19/05/25.
//

import SwiftUI

struct CategoriesButton: View {
    let categories: [String]
    var onCategoryTap: ((String) -> Void)? = nil
    var body: some View {
        HStack(alignment: .center) {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    onCategoryTap?(category)
                }) {
                    Image(category.lowercased())
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
    CategoriesButton(categories: ["atasan", "bawahan", "terusan", "perbaikan"])
}
