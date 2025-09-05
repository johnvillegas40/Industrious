import SwiftUI
import CoreData
import UserNotifications

struct StudyDetailView: View {
    @ObservedObject var study: Study
    @Environment(\.managedObjectContext) private var context
    @State private var showingStart = false

    var body: some View {
        List {
            Section("Reminder") {
                DatePicker("Next Visit", selection: Binding(
                    get: { study.nextVisit ?? Date() },
                    set: { newValue in
                        study.nextVisit = newValue
                        try? context.save()
                        NotificationManager.shared.schedule(study: study)
                    }
                ), displayedComponents: [.date, .hourAndMinute])
                if study.nextVisit != nil {
                    Button("Clear Reminder") {
                        study.nextVisit = nil
                        try? context.save()
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [study.notificationID])
                    }
                }
            }
            Section("Sessions") {
                ForEach(study.sessionsArray, id: \.id) { session in
                    VStack(alignment: .leading) {
                        Text(session.start, style: .date)
                        Text(session.start, style: .time)
                            .font(Typography.caption())
                    }
                }
            }
        }
        .navigationTitle(study.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Start") { showingStart = true }
            }
        }
        .sheet(isPresented: $showingStart) {
            StartSessionView(study: study)
        }
    }
}

struct StudyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let study = Study(context: context)
        study.id = UUID()
        study.title = "Preview"
        return StudyDetailView(study: study)
            .environment(\.managedObjectContext, context)
    }
}
