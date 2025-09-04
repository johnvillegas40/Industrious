import SwiftUI

struct HistoryView: View {
    var body: some View {
        Text("History")
            .font(Typography.heading())
            .foregroundStyle(AppColor.textPrimary)
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
    }
}

#Preview {
    HistoryView()
}
