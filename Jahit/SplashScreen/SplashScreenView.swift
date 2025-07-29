//
//  SplashScreenView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 05/05/25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 7) {
            Image("JahitLogo")
            Text("Jahit")
              .font(
                Font.custom("PlusJakartaSans-Regular", size: 40)
                  .weight(.bold)
              )
              .foregroundColor(Color(red: 0, green: 0.37, blue: 0.92))
                
        }
        .frame(alignment: .center)
    }
}

#Preview {
    SplashScreenView()
}
