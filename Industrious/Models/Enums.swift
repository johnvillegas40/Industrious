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

enum GoalPeriod: String, CaseIterable, Codable {
    case weekly
    case monthly
    case counter
}

enum CompanionType: String, CaseIterable, Codable {
    case solo
    case friend
    case group
}

enum Role: String, CaseIterable, Codable {
    case publisher
    case pioneer

    var displayName: String {
        switch self {
        case .publisher: "Publisher"
        case .pioneer: "Pioneer"
        }
    }

    var creditAllowance: Int {
        switch self {
        case .publisher: 0
        case .pioneer: 60
        }
    }

    var dayOffAllowance: Int {
        switch self {
        case .publisher: 0
        case .pioneer: 3
        }
    }

    var allowsCredit: Bool { creditAllowance > 0 }
    var allowsDaysOff: Bool { dayOffAllowance > 0 }
}

