import SwiftUI

@main
struct TheCatApp: App {

    @State private var coordinator = Coordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(screen: .contentView)
                    .navigationDestination(for: Coordinator.Route.self) { screen in
                    coordinator.build(screen: screen)
                }
                .navigationTitle(Localized.Breeds.title)
            }
        }
    }
}
