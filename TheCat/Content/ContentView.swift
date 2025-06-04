import SwiftUI

struct ContentView: View {

    @State private var selectedTab: Tab = .breeds
    @State private var coordinator = Coordinator()

    enum Tab {
        case breeds
        case favorites
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(screen: .breedsView)
                    .navigationDestination(for: Coordinator.Route.self) { screen in
                    coordinator.build(screen: screen)
                }
            }
            .tabItem {
                Label(Localized.Breeds.catsListButton, systemImage: Constants.Image.catsList)
            }
            .tag(Tab.breeds)

            NavigationStack(path: $coordinator.path) {
                coordinator.build(screen: .favoritesView)
                    .navigationDestination(for: Coordinator.Route.self) { screen in
                        coordinator.build(screen: screen)
                    }
            }
            .tabItem {
                Label(Localized.Breeds.favouritesButton, systemImage: Constants.Image.favorites)
            }
            .tag(Tab.favorites)
        }
        .navigationDestination(for: Coordinator.Route.self) { route in
            coordinator.build(screen: route)
        }
        .sheet(item: $coordinator.presentedBreedDetails) { breed in
            coordinator.buildBreedDetailsView(breed: breed)
        }
    }
}

// MARK: Preview

#if targetEnvironment(simulator)
#Preview {
    ContentView()
}
#endif
