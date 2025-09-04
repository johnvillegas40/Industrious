import SwiftUI

struct SettingsView: View {
    var body: some View {
        Text("Settings")
            .font(Typography.heading())
            .foregroundStyle(AppColor.textPrimary)
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
    }
}

#Preview {
    SettingsView()
}
