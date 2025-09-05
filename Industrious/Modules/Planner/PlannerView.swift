import SwiftUI

struct PlannerView: View {
    var body: some View {
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }
}

#Preview {
    PlannerView()
}
