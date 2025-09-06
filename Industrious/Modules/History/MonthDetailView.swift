import SwiftUI
@_implementationOnly import CoreData
struct MonthDetailView: View {
    @Environment(\.managedObjectContext) private var context
    let month: Int
    let year: Int

    @State private var sessions: [Session] = []
    @State private var selectedActivity: ActivityType? = nil
    @State private var showOnlyCredit = false

    @State private var fieldMinutes: Int = 0
    @State private var creditMinutes: Int64 = 0
    @State private var counterTotal: Int64 = 0

    @State private var showShare = false
    @State private var exportText = ""

    var body: some View {
        List {
            summaryBar
            ForEach(filteredSessions) { session in
                VStack(alignment: .leading) {
                    Text(dateFormatter.string(from: session.start))
                        .font(.headline)
                    Text(detailText(for: session))
                        .font(.caption)
                }
            }
        }
        .navigationTitle("\(monthName(month)) \(year)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Activity", selection: $selectedActivity) {
                        Text("All").tag(ActivityType?.none)
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(ActivityType?.some(type))
                        }
                    }
                    Toggle("Credit Only", isOn: $showOnlyCredit)
                    Divider()
                    Button("Export CSV") { export(format: .csv, rounding: 0) }
                    Button("Export CSV (15m)") { export(format: .csv, rounding: 15) }
                    Button("Export Text") { export(format: .plain, rounding: 0) }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear(perform: load)
        .sheet(isPresented: $showShare) {
            ShareSheet(items: [exportText])
        }
    }

    private var filteredSessions: [Session] {
        sessions.filter { session in
            (selectedActivity == nil || session.activityType == selectedActivity) &&
            (!showOnlyCredit || session.isCreditHour)
        }
    }

    private var summaryBar: some View {
        HStack {
            Text("Field: \(hoursString(from: fieldMinutes))")
            Spacer()
            Text("Credit: \(hoursString(from: Int(creditMinutes)))")
            Spacer()
            Text("Counters: \(counterTotal)")
        }
        .font(.caption)
        .padding(.vertical, 4)
    }

    private func load() {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        let start = calendar.date(from: comps) ?? Date()
        let end = calendar.date(byAdding: .month, value: 1, to: start) ?? start

        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "start >= %@ AND start < %@", start as NSDate, end as NSDate)
        sessions = (try? context.fetch(request)) ?? []

        fieldMinutes = sessions.reduce(0) { $0 + Int($1.end.timeIntervalSince($1.start) / 60) }
        creditMinutes = sessions.reduce(0) { $0 + $1.creditMinutes }

        let counters = (try? Aggregator.counterTotalsByMonth(context: context)) ?? [:]
        let key = MonthKey(year: year, month: month)
        counterTotal = counters[key] ?? 0
    }

    private func export(format: ExportFormat, rounding: Int) {
        exportText = makeExport(format: format, rounding: rounding)
        showShare = true
    }

    private func makeExport(format: ExportFormat, rounding: Int) -> String {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        switch format {
        case .csv:
            var lines: [String] = ["Start,End,Activity,DurationMinutes,CreditMinutes,Notes"]
            for s in filteredSessions {
                let duration = Int(s.end.timeIntervalSince(s.start) / 60)
                let rounded = rounding == 0 ? duration : ((duration + rounding/2) / rounding) * rounding
                lines.append("\(df.string(from: s.start)),\(df.string(from: s.end)),\(s.activityType.rawValue),\(rounded),\(s.creditMinutes),\(s.notes ?? "")")
            }
            return lines.joined(separator: "\n")
        case .plain:
            var lines: [String] = []
            for s in filteredSessions {
                let duration = Int(s.end.timeIntervalSince(s.start) / 60)
                lines.append("\(df.string(from: s.start)) - \(s.activityType.rawValue) \(duration)m")
            }
            return lines.joined(separator: "\n")
        }
    }

    private func detailText(for session: Session) -> String {
        let duration = Int(session.end.timeIntervalSince(session.start) / 60)
        return "\(session.activityType.rawValue.capitalized) \(duration)m"
    }

    private func hoursString(from minutes: Int) -> String {
        String(format: "%.1f", Double(minutes) / 60.0)
    }

    private func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.monthSymbols[month - 1]
    }

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }
}

private enum ExportFormat {
    case csv
    case plain
}

struct MonthDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MonthDetailView(month: 1, year: 2024)
    }
}
