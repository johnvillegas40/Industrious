import Foundation

enum ActivityType: String, CaseIterable, Codable {
    case study
    case breakTime
    case meeting
    case other
}

enum CounterKind: String, CaseIterable, Codable {
    case session
    case dayOff
    case goal
}

enum CompanionType: String, CaseIterable, Codable {
    case solo
    case friend
    case group
}

