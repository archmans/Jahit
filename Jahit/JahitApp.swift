//
//  JahitApp.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 05/05/25.
//

import SwiftUI

@main
struct JahitApp: App {
    @StateObject private var userManager = UserManager.shared
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(userManager)
                .background(Color.white)
                .onAppear {
                    userManager.requestLocationOnAppLaunch()
                }
        }
    }
}
