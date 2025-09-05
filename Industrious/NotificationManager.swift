import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() { }

    func schedule(study: Study) {
        guard let date = study.nextVisit else { return }
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = "Next Visit"
            content.body = "Visit \(study.title)"
            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let request = UNNotificationRequest(identifier: study.notificationID, content: content, trigger: trigger)
            center.removePendingNotificationRequests(withIdentifiers: [study.notificationID])
            center.add(request)
        }
    }
}

extension Study {
    var notificationID: String { "study-\(id.uuidString)" }
}
