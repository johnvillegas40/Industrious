import SwiftUI

struct PlannerView: View {
    var body: some View {
        Text("Planner")
            .font(Typography.heading())
            .foregroundStyle(AppColor.textPrimary)
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
    }
}

#Preview {
    PlannerView()
}
