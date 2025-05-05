//
//  JahitApp.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 05/05/25.
//

import SwiftUI
import SwiftData

@main
struct JahitApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            ContentView()
            SplashScreenView()
                
        }
        .modelContainer(sharedModelContainer)
    }
}
