import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct RootView: View {
    init() {
        #if canImport(UIKit)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.88, alpha: 1)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.16)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }

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
        .toolbarBackground(NullTheme.paper, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
