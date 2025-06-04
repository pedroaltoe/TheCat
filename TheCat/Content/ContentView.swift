import SwiftUI

struct ContentView: View {

    @State private var coordinator = Coordinator()

    var body: some View {
        TabView {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(screen: .breedsView)
                    .navigationDestination(for: Coordinator.Route.self) { screen in
                    coordinator.build(screen: screen)
                }
            }
            .tabItem {
                Label(Localized.Breeds.catsListButton, systemImage: Constants.Image.catsList)
            }

            NavigationStack(path: $coordinator.path) {
                coordinator.build(screen: .favoritesView)
                    .navigationDestination(for: Coordinator.Route.self) { screen in
                        coordinator.build(screen: screen)
                    }
            }
            .tabItem {
                Label(Localized.Breeds.favouritesButton, systemImage: Constants.Image.favorites)
            }
        }
    }
}

// MARK: Preview

#if targetEnvironment(simulator)
#Preview {
    ContentView()
}
#endif
