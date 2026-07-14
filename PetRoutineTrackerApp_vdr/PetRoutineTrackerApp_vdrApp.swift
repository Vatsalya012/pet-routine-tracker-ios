//
//  PetRoutineTrackerApp_vdrApp.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 02/12/25.
//

import SwiftUI

@main
struct PetRoutineTrackerApp_vdrApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
