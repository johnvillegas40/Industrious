//
//  Persistence.swift
//  Industrious
//
//  Created by Johnny Villegas on 9/3/25.
//
@_implementationOnly import CoreData
struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        SampleData.seedPreview(context: viewContext)
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Industrious")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        let desc = container.persistentStoreDescriptions.first
        desc?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        desc?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        container.loadPersistentStores { [self] (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo). Falling back to in-memory store.")
                container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
                container.loadPersistentStores { (_, error) in
                    if let error = error as NSError? {
                        print("Failed to load in-memory store: \(error), \(error.userInfo)")
                    }
                }
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        try? MigrationHelper.migrateLegacyItems(context: container.viewContext)
    }
}
