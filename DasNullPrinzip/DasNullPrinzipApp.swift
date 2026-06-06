import SwiftUI

@main
struct DasNullPrinzipApp: App {
    @StateObject private var store = NullStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
