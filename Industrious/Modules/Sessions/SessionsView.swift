import SwiftUI

struct SessionsView: View {
    @State private var showingStart = false

    var body: some View {
        VStack {
            Button("Start Session") { showingStart = true }
                .font(Typography.heading())
                .foregroundStyle(AppColor.textPrimary)
                .padding(Spacing.m)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .sheet(isPresented: $showingStart) {
            StartSessionView()
        }
    }
}

#Preview {
    SessionsView()
}
