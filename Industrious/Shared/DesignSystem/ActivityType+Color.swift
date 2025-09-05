import SwiftUI

extension ActivityType {
    var color: Color {
        switch self {
        case .study: return .blue
        case .breakTime: return .green
        case .meeting: return .orange
        case .other: return .gray
        }
    }
}
