import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() { }

    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func schedule(study: Study) {
        guard let date = study.nextVisit else { return }
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Next Visit"
        content.body = "Visit \(study.title)"
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: study.notificationID, content: content, trigger: trigger)
        center.removePendingNotificationRequests(withIdentifiers: [study.notificationID])
        center.add(request)
    }

    func schedule(session: PlannedSession) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Planned Session"
        content.body = session.activity.rawValue.capitalized
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: session.start)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: session.id.uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func nudgeIfOffPace(goal: Goal) {
        let center = UNUserNotificationCenter.current()
        let now = Date()
        let calendar = Calendar.current
        let interval: DateInterval?
        switch goal.period {
        case .weekly:
            interval = calendar.dateInterval(of: .weekOfYear, for: now)
        case .monthly:
            interval = calendar.dateInterval(of: .month, for: now)
        case .counter:
            interval = nil
        }
        guard let period = interval, goal.target > 0 else { return }
        let elapsed = now.timeIntervalSince(period.start)
        let total = period.end.timeIntervalSince(period.start)
        let expected = goal.target * elapsed / total
        if goal.progress < expected {
            let content = UNMutableNotificationContent()
            content.title = "Keep Going"
            content.body = "You're behind on \(goal.title)"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let id = "goal-nudge-\(goal.id.uuidString)"
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            center.removePendingNotificationRequests(withIdentifiers: [id])
            center.add(request)
        }
    }
}

extension Study {
    var notificationID: String { "study-\(id.uuidString)" }
}
