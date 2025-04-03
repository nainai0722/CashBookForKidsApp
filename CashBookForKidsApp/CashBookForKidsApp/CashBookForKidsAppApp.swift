//
//  CashBookForKidsAppApp.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/03.
//

import SwiftUI
import SwiftData

@main
struct CashBookForKidsAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Money.self,
            UserInfo.self,
            TodayData.self,
            Routine.self,
            RoutineTitle.self
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
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
