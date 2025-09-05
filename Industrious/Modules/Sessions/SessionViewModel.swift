import Foundation
import CoreData

@MainActor
class SessionViewModel: ObservableObject {
    @Published var selectedActivity: ActivityType = .study
    @Published var isCreditHour: Bool = false
    @Published var selectedRole: Role = .publisher
    @Published var selectedCompanion: CompanionType = .solo
    @Published var notes: String = ""
    @Published var assignmentTag: String = ""
    @Published var elapsed: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var counter: Int = 0
    @Published var selectedStudy: Study?

    private var timer: Timer?
    private var startDate: Date?

    init(study: Study? = nil) {
        self.selectedStudy = study
    }

    func start() {
        startDate = Date()
        elapsed = 0
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let startDate = self.startDate else { return }
            self.elapsed = Date().timeIntervalSince(startDate)
        }
    }

    func stop(context: NSManagedObjectContext) {
        guard let startDate = startDate else { return }
        timer?.invalidate()
        isRunning = false
        let endDate = Date()

        let session = Session(context: context)
        session.id = UUID()
        session.start = startDate
        session.end = endDate
        session.activityType = selectedActivity
        session.isCreditHour = isCreditHour
        session.creditMinutes = Int64(isCreditHour ? counter : 0)
        session.assignmentTag = assignmentTag.isEmpty ? nil : assignmentTag
        session.companion = selectedCompanion
        session.notes = notes.isEmpty ? nil : notes
        session.study = selectedStudy

        do {
            try context.save()
        } catch {
            print("Failed to save session: \(error)")
        }

        reset()
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        elapsed = 0
        startDate = nil
        isRunning = false
    }

    var timeString: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: elapsed) ?? "00:00:00"
    }
}
