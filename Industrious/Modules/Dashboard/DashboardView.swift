import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var totals: [CounterKind: Int64] = [:]
    @State private var weeklySessions: [DailyStat] = []
    @State private var showingStart = false

    private var progress: Double {
        let goal = Double(totals[.goal] ?? 0)
        guard goal > 0 else { return 0 }
        return min(Double(totals[.session] ?? 0) / goal, 1)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    StartSessionCard { showingStart = true }
                        .padding(.horizontal, Spacing.m)

                    ProgressRingView(progress: progress)
                        .frame(height: 150)
                        .padding(.horizontal, Spacing.m)

                    WeeklyBarChartView(data: weeklySessions)
                        .frame(height: 150)
                        .padding(.horizontal, Spacing.m)

                    CountersGridView(totals: totals)
                        .padding(.horizontal, Spacing.m)

                    SPFMPanel()
                        .padding(.horizontal, Spacing.m)
                }
                .padding(.vertical, Spacing.m)
            }
            .background(AppColor.background)
            .navigationTitle("Dashboard")
        }
        .sheet(isPresented: $showingStart) {
            StartSessionView()
        }
        .onAppear(perform: load)
    }

    private func load() {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month], from: Date())
        guard let year = comps.year, let month = comps.month else { return }
        let key = MonthKey(year: year, month: month)
        var result: [CounterKind: Int64] = [:]
        for kind in CounterKind.allCases {
            let data = (try? CountersAggregator.monthlyTotals(context: context, kind: kind)) ?? [:]
            result[kind] = data[key] ?? 0
        }
        totals = result

        var weekly: [DailyStat] = []
        for i in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: -6 + i, to: Date()) else { continue }
            let start = calendar.startOfDay(for: day)
            guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { continue }
            let request: NSFetchRequest<Session> = Session.fetchRequest()
            request.predicate = NSPredicate(format: "start >= %@ AND start < %@", start as NSDate, end as NSDate)
            let count = (try? context.count(for: request)) ?? 0
            weekly.append(DailyStat(date: day, value: count))
        }
        weeklySessions = weekly
    }
}

#Preview {
    DashboardView()
}
