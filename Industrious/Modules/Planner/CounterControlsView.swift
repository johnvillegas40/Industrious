import SwiftUI
import CoreData

struct CounterControlsView: View {
    @Environment(\.managedObjectContext) private var context
    let kind: CounterKind
    @FetchRequest private var entries: FetchedResults<CounterEntry>

    init(kind: CounterKind) {
        self.kind = kind
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: 0), to: startOfMonth)!
        _entries = FetchRequest(
            entity: CounterEntry.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "kindRaw == %@ AND date >= %@ AND date < %@", kind.rawValue, startOfMonth as NSDate, endOfMonth as NSDate)
        )
    }

    private var total: Int64 {
        entries.reduce(0) { $0 + $1.value }
    }

    var body: some View {
        HStack(spacing: Spacing.l) {
            Button(action: { add(value: -1) }) {
                Image(systemName: "minus.circle.fill")
                    .font(.largeTitle)
            }
            Text("\(total)")
                .font(Typography.heading(36))
            Button(action: { add(value: 1) }) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
            }
        }
        .padding(Spacing.m)
    }

    private func add(value: Int64) {
        let entry = CounterEntry(context: context)
        entry.id = UUID()
        entry.date = Date()
        entry.kind = kind
        entry.value = value
        try? context.save()
    }
}

#Preview {
    CounterControlsView(kind: .session)
}
