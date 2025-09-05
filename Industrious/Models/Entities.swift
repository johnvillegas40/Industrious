import Foundation
import CoreData

@objc(Session)
public class Session: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var start: Date
    @NSManaged public var end: Date
    @NSManaged public var activityTypeRaw: String
    @NSManaged public var isCreditHour: Bool
    @NSManaged public var companionRaw: String
    @NSManaged public var notes: String?
    @NSManaged public var creditMinutes: Int64
    @NSManaged public var assignmentTag: String?
    @NSManaged public var study: Study?

    public var activityType: ActivityType {
        get { ActivityType(rawValue: activityTypeRaw) ?? .study }
        set { activityTypeRaw = newValue.rawValue }
    }

    public var companion: CompanionType {
        get { CompanionType(rawValue: companionRaw) ?? .solo }
        set { companionRaw = newValue.rawValue }
    }
}

extension Session {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        NSFetchRequest<Session>(entityName: "Session")
    }
}

@objc(CounterEntry)
public class CounterEntry: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var kindRaw: String
    @NSManaged public var value: Int64

    public var kind: CounterKind {
        get { CounterKind(rawValue: kindRaw) ?? .session }
        set { kindRaw = newValue.rawValue }
    }
}

extension CounterEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CounterEntry> {
        NSFetchRequest<CounterEntry>(entityName: "CounterEntry")
    }
}

@objc(Study)
public class Study: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var sessions: Set<Session>?
    @NSManaged public var nextVisit: Date?

    public var sessionsArray: [Session] {
        sessions?.sorted { $0.start < $1.start } ?? []
    }
}

extension Study {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Study> {
        NSFetchRequest<Study>(entityName: "Study")
    }
}

@objc(DayOff)
public class DayOff: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var isConvention: Bool
}

extension DayOff {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayOff> {
        NSFetchRequest<DayOff>(entityName: "DayOff")
    }
}

@objc(Goal)
public class Goal: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var target: Double
    @NSManaged public var periodRaw: String
    @NSManaged public var progress: Double

    public var period: GoalPeriod {
        get { GoalPeriod(rawValue: periodRaw) ?? .weekly }
        set { periodRaw = newValue.rawValue }
    }
}

extension Goal {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        NSFetchRequest<Goal>(entityName: "Goal")
    }
}

@objc(Preference)
public class Preference: NSManagedObject {
    @NSManaged public var key: String
    @NSManaged public var value: String?
}

extension Preference {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Preference> {
        NSFetchRequest<Preference>(entityName: "Preference")
    }
}

