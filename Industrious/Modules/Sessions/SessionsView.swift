import SwiftUI

struct SessionsView: View {
    var body: some View {
        Text("Sessions")
            .font(Typography.heading())
            .foregroundStyle(AppColor.textPrimary)
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
    }
}

#Preview {
    SessionsView()
}
