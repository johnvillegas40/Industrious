import SwiftUI
import UIKit

struct SessionsView: View {
    @State private var showingStart = false

    var body: some View {
        VStack {
            Button("Start Session") {
                showingStart = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            .font(Typography.heading())
            .foregroundStyle(AppColor.textPrimary)
            .frame(minHeight: 44)
            .padding(Spacing.m)
            .accessibilityLabel("Start a session")
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
