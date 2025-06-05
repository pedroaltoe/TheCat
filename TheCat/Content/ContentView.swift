import ComposableArchitecture
import SwiftUI

struct ContentView: View {

    enum Tab {
        case breeds
        case favorites
    }

    @State private var selectedTab: Tab
    @Bindable private var coordinator: Coordinator

    let contentViewModel: ContentViewModel
    let breedsViewModel: BreedsViewModel
    let favoritesViewModel: FavoritesViewModel

    init(
        coordinator: Coordinator,
        contentViewModel: ContentViewModel
    ) {
        selectedTab = .breeds
        self.coordinator = coordinator
        self.contentViewModel = contentViewModel

        breedsViewModel = BreedsViewModel(
            contentViewModel: contentViewModel,
            coordinator: coordinator
        )

        favoritesViewModel = FavoritesViewModel(
            contentViewModel: contentViewModel,
            coordinator: coordinator
        )
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                BreedsView(viewModel: breedsViewModel)
                    .navigationTitle(Localized.Breeds.title)
            }
            .tabItem {
                Label(Localized.Breeds.catsListButton, systemImage: Constants.Image.catsList)
            }
            .tag(Tab.breeds)

            NavigationStack {
                FavoritesView(viewModel: favoritesViewModel)
                    .navigationTitle(Localized.Favorites.title)
            }
            .tabItem {
                Label(Localized.Breeds.favouritesButton, systemImage: Constants.Image.favorites)
            }
            .tag(Tab.favorites)
        }
        .sheet(item: $coordinator.presentedBreedDetails) { breed in
            NavigationStack {
                BreedDetailsFeatureView(
                    store: Store(initialState: BreedDetailsFeature.State(breed: breed)) {
                        BreedDetailsFeature(contentViewModel: contentViewModel)
                    }
                )
                .navigationTitle(breed.name)
            }
        }
    }
}

// MARK: Preview

#if targetEnvironment(simulator)
#Preview {
    let coordinator = MockCoordinator()
    let contentViewModel = ContentViewModel(repository: RepositoryBuilder.makeRepository(api: APIClientMock()))
    ContentView(
        coordinator: coordinator,
        contentViewModel: contentViewModel
    )
}
#endif
