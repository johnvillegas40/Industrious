import SwiftUI

struct StudiesView: View {
    var body: some View {
        Text("Studies")
            .font(Typography.heading())
            .foregroundStyle(AppColor.textPrimary)
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
    }
}

#Preview {
    StudiesView()
}
