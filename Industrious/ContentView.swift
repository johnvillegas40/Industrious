import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    SFSymbol.dashboard.image
                    Text("Dashboard")
                }
            SessionsView()
                .tabItem {
                    SFSymbol.sessions.image
                    Text("Sessions")
                }
            PlannerView()
                .tabItem {
                    SFSymbol.planner.image
                    Text("Planner")
                }
            StudiesView()
                .tabItem {
                    SFSymbol.studies.image
                    Text("Studies")
                }
            HistoryView()
                .tabItem {
                    SFSymbol.history.image
                    Text("History")
                }
            SettingsView()
                .tabItem {
                    SFSymbol.settings.image
                    Text("Settings")
                }
        }
        .tint(AppColor.primary)
    }
}

#Preview {
    ContentView()
}
