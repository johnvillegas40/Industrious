import SwiftUI

enum SFSymbol: String {
    case dashboard = "rectangle.grid.2x2"
    case sessions = "clock"
    case planner = "calendar"
    case studies = "book"
    case history = "clock.arrow.circlepath"
    case settings = "gear"

    var image: Image {
        Image(systemName: rawValue)
    }
}
