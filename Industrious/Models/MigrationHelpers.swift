import Foundation
import CoreData

struct MigrationHelper {
    static func migrateLegacyItems(context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Item")
        let items = try context.fetch(request)
        guard !items.isEmpty else { return }
        for item in items {
            let session = Session(context: context)
            session.id = UUID()
            if let timestamp = item.value(forKey: "timestamp") as? Date {
                session.start = timestamp
                session.end = timestamp
            } else {
                let now = Date()
                session.start = now
                session.end = now
            }
            session.activityType = .study
            context.delete(item)
        }
        try context.save()
    }
}

