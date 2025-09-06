import Foundation
@_implementationOnly import CoreData
struct MonthKey: Hashable {
    let year: Int
    let month: Int
}

struct Aggregator {
    static func sessionDurationsByMonth(context: NSManagedObjectContext, activity: ActivityType? = nil) throws -> [MonthKey: TimeInterval] {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        if let activity = activity {
            request.predicate = NSPredicate(format: "activityTypeRaw == %@", activity.rawValue)
        }
        let sessions = try context.fetch(request)
        var result: [MonthKey: TimeInterval] = [:]
        let calendar = Calendar.current
        for session in sessions {
            let components = calendar.dateComponents([.year, .month], from: session.start)
            guard let year = components.year, let month = components.month else { continue }
            let key = MonthKey(year: year, month: month)
            let duration = session.end.timeIntervalSince(session.start)
            result[key, default: 0] += duration
        }
        return result
    }

    static func counterTotalsByMonth(context: NSManagedObjectContext, kind: CounterKind? = nil) throws -> [MonthKey: Int64] {
        let request: NSFetchRequest<CounterEntry> = CounterEntry.fetchRequest()
        if let kind = kind {
            request.predicate = NSPredicate(format: "kindRaw == %@", kind.rawValue)
        }
        let entries = try context.fetch(request)
        var result: [MonthKey: Int64] = [:]
        let calendar = Calendar.current
        for entry in entries {
            let components = calendar.dateComponents([.year, .month], from: entry.date)
            guard let year = components.year, let month = components.month else { continue }
            let key = MonthKey(year: year, month: month)
            result[key, default: 0] += entry.value
        }
        return result
    }
}

