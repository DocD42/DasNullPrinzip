import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Heute", systemImage: "0.circle") }

            TrackerView()
                .tabItem { Label("Tracker", systemImage: "square.grid.3x3") }

            RipeningView()
                .tabItem { Label("Reifen", systemImage: "hourglass") }

            ExcuseLabView()
                .tabItem { Label("Ausreden", systemImage: "text.bubble") }

            ChallengeView()
                .tabItem { Label("30 Tage", systemImage: "calendar") }
        }
        .tint(NullTheme.oxblood)
    }
}
