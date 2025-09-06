import SwiftUI
@_implementationOnly import CoreData
struct DayOffLoggingView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: DayOff.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DayOff.date, ascending: false)]
    ) private var daysOff: FetchedResults<DayOff>

    @State private var selectedRole: Role = .publisher

    private var dayOffCount: Int {
        daysOff.filter { !$0.isConvention }.count
    }

    var body: some View {
        VStack {
            Picker("Role", selection: $selectedRole) {
                ForEach(Role.allCases, id: \.self) { role in
                    Text(role.displayName).tag(role)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            if selectedRole.allowsDaysOff {
                HStack {
                    Button("Log Day Off") { addDayOff(convention: false) }
                    Button("Log Convention Day") { addDayOff(convention: true) }
                }
                .padding()

                if dayOffCount > selectedRole.dayOffAllowance {
                    Text("Day-off allowance exceeded")
                        .foregroundColor(.orange)
                }
            } else {
                Button("Log Convention Day") { addDayOff(convention: true) }
                    .padding()
            }

            List {
                ForEach(daysOff, id: \.objectID) { day in
                    HStack {
                        Text(day.date, style: .date)
                        if day.isConvention {
                            Spacer()
                            Text("Convention")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteDays)
            }
        }
    }

    private func addDayOff(convention: Bool) {
        let entry = DayOff(context: context)
        entry.id = UUID()
        entry.date = Date()
        entry.isConvention = convention
        try? context.save()
    }

    private func deleteDays(at offsets: IndexSet) {
        offsets.map { daysOff[$0] }.forEach(context.delete)
        try? context.save()
    }
}

#Preview {
    DayOffLoggingView()
}
