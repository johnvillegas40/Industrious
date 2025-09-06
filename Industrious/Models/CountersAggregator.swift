import Foundation
@_implementationOnly import CoreData
struct CountersAggregator {
    static func monthlyTotals(context: NSManagedObjectContext, kind: CounterKind? = nil) throws -> [MonthKey: Int64] {
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

