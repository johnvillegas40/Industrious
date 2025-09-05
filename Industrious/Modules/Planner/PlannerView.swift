import SwiftUI

struct PlannerView: View {
    var body: some View {
        DayOffLoggingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
    }
}

#Preview {
    PlannerView()
}
