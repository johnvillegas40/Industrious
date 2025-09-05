import Foundation

struct PlannedSession: Identifiable, Codable {
    var id = UUID()
    var start: Date
    var activity: ActivityType
}
