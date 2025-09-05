import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var totals: [MonthKey: Int64] = [:]

    var body: some View {
        NavigationStack {
            List(sortedKeys, id: \.self) { key in
                NavigationLink {
                    MonthDetailView(month: key.month, year: key.year)
                } label: {
                    HStack {
                        Text("\(monthName(key.month)) \(key.year)")
                        Spacer()
                        Text("\(totals[key] ?? 0)")
                    }
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .navigationTitle("History")
        }
        .onAppear(perform: load)
    }

    private var sortedKeys: [MonthKey] {
        totals.keys.sorted { a, b in
            if a.year == b.year { return a.month > b.month }
            return a.year > b.year
        }
    }

    private func load() {
        totals = (try? CountersAggregator.monthlyTotals(context: context)) ?? [:]
    }

    private func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.monthSymbols[month - 1]
    }
}

#Preview {
    HistoryView()
}
