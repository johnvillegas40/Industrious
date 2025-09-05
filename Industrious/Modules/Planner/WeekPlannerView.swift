import SwiftUI

struct WeekPlannerView: View {
    @State private var sessions: [PlannedSession] = []
    @State private var isAdding = false
    @State private var newDate = Date()

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(currentWeek(), id: \.self) { day in
                VStack(alignment: .leading) {
                    Text(dayFormatter.string(from: day))
                        .font(.headline)
                    ForEach(sessions.filter { Calendar.current.isDate($0.start, inSameDayAs: day) }) { session in
                        Text("\(timeFormatter.string(from: session.start)) \(session.activity.rawValue.capitalized)")
                            .padding(4)
                            .background(session.activity.color.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                .padding(.vertical, 4)
                .onTapGesture {
                    newDate = day
                    isAdding = true
                }
            }
        }
        .padding()
        .navigationTitle("Week Planner")
        .sheet(isPresented: $isAdding) {
            AddSessionView(date: newDate) { session in
                sessions.append(session)
                NotificationManager.shared.schedule(session: session)
            }
        }
    }

    private func currentWeek() -> [Date] {
        let cal = Calendar.current
        let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: start) }
    }

    private var dayFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        return df
    }

    private var timeFormatter: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .short
        return df
    }
}

struct AddSessionView: View {
    var date: Date
    var onAdd: (PlannedSession) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var time = Date()
    @State private var activity: ActivityType = .study

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                Picker("Activity", selection: $activity) {
                    ForEach(ActivityType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
            }
            .navigationTitle("New Session")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let start = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: time), minute: Calendar.current.component(.minute, from: time), second: 0, of: date) ?? date
                        onAdd(PlannedSession(start: start, activity: activity))
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WeekPlannerView()
    }
}
