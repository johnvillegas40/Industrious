//
//  IndustriousApp.swift
//  Industrious
//
//  Created by Johnny Villegas on 9/3/25.
//

import SwiftUI
import CoreData

@main
struct IndustriousApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
