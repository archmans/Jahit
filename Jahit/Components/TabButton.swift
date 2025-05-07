//
//  NavButton.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 07/05/25.
//

import SwiftUI

struct TabButton: View {
    var isSelected: Bool = false
    var title: String
    var icon: String
    var filledIcon: String
    var didSelect: () -> Void
    var body: some View {
        Button {
            debugPrint("TabButton pressed")
            didSelect()
        } label: {
            VStack {
                Image(isSelected ? filledIcon : icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .fontWeight(.semibold)
            }
        }
        .foregroundColor(isSelected ? Color(red: 0, green: 0.37, blue: 0.92) : Color(red: 0.38, green: 0.38, blue: 0.38))
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

#Preview {
    TabButton(
        isSelected: false,
        title: "Home",
        icon: "home",
        filledIcon: "home.fill",
        didSelect: {}
    )
}
