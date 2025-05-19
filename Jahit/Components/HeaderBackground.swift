//
//  HeaderBackground.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 18/05/25.
//

import SwiftUI

struct HeaderBackground: View {
    var body: some View {
        LinearGradient(
            stops : [
                Gradient.Stop(color: Color(red: 0, green: 0.37, blue: 0.92), location: 0.00),
                Gradient.Stop(color: Color(red: 0.39, green: 0.63, blue: 1), location: 1.00),
            ],
            startPoint: .bottom,
            endPoint: .top
        )
        .clipShape(RoundedCorner(radius: 18, corners: [.bottomLeft, .bottomRight]))
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    HeaderBackground()
}
