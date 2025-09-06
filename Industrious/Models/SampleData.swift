import Foundation
@_implementationOnly import CoreData
struct SampleData {
    @discardableResult
    static func insertSampleData(context: NSManagedObjectContext) -> ([Session], [CounterEntry]) {
        let calendar = Calendar.current

        let session1 = Session(context: context)
        session1.id = UUID()
        session1.start = calendar.date(from: DateComponents(year: 2024, month: 1, day: 10, hour: 9))!
        session1.end = session1.start.addingTimeInterval(3600) // 1 hour
        session1.activityType = .study
        session1.companion = .solo
        session1.isCreditHour = false
        session1.creditMinutes = 0

        let session2 = Session(context: context)
        session2.id = UUID()
        session2.start = calendar.date(from: DateComponents(year: 2024, month: 2, day: 5, hour: 10))!
        session2.end = session2.start.addingTimeInterval(7200) // 2 hours
        session2.activityType = .breakTime
        session2.companion = .friend
        session2.isCreditHour = false
        session2.creditMinutes = 0

        let entry1 = CounterEntry(context: context)
        entry1.id = UUID()
        entry1.date = calendar.date(from: DateComponents(year: 2024, month: 1, day: 15))!
        entry1.kind = .session
        entry1.value = 3

        let entry2 = CounterEntry(context: context)
        entry2.id = UUID()
        entry2.date = calendar.date(from: DateComponents(year: 2024, month: 2, day: 20))!
        entry2.kind = .session
        entry2.value = 5

        try? context.save()
        return ([session1, session2], [entry1, entry2])
    }

    static var plannedSessions: [PlannedSession] {
        let calendar = Calendar.current
        return [
            PlannedSession(start: calendar.date(from: DateComponents(year: 2024, month: 3, day: 1, hour: 9))!, activity: .study),
            PlannedSession(start: calendar.date(from: DateComponents(year: 2024, month: 3, day: 2, hour: 10))!, activity: .meeting)
        ]
    }

    static func seedPreview(context: NSManagedObjectContext) {
        _ = insertSampleData(context: context)
    }
}

