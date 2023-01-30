//
//  LocationReminderApp.swift
//  LocationReminder
//
//  Created by joker on 2023/1/14.
//

import SwiftUI

@main
struct LocationReminderApp: App {
    let persistenceController = PersistenceController.shared
    let appModel = AppModel()
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            MapPage().environmentObject(appModel)
        }
    }
}
