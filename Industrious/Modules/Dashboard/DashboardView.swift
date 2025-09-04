import SwiftUI

struct DashboardView: View {
    var body: some View {
        Text("Dashboard")
            .font(Typography.heading())
            .foregroundStyle(AppColor.textPrimary)
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
    }
}

#Preview {
    DashboardView()
}
