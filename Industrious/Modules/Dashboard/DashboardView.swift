import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var totals: [CounterKind: Int64] = [:]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Dashboard")
                .font(Typography.heading())
                .foregroundStyle(AppColor.textPrimary)
                .padding(Spacing.m)

            ForEach(CounterKind.allCases, id: \.self) { kind in
                HStack {
                    Text(kind.rawValue.capitalized)
                    Spacer()
                    Text("\(totals[kind] ?? 0)")
                }
                .padding(.horizontal, Spacing.m)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
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
    }
}

#Preview {
    DashboardView()
}
