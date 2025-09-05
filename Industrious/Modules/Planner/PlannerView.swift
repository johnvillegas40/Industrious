import SwiftUI

struct PlannerView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(CounterKind.allCases, id: \.self) { kind in
                    HStack {
                        Text(kind.rawValue.capitalized)
                        Spacer()
                        CounterControlsView(kind: kind)
                    }
                    .padding(.horizontal, Spacing.m)
                }
                Divider()
                    .padding(.vertical, Spacing.m)
                DayOffLoggingView()
                NavigationLink("Week Planner") {
                    WeekPlannerView()
                }
                .padding(.top, Spacing.l)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .navigationTitle("Planner")
        }
    }
}

#Preview {
    PlannerView()
}
