//
//  notifications_exampleApp.swift
//  notifications example
//
//  Created by ynom on 12/22/20.
//

import SwiftUI

@main
struct notifications_exampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
