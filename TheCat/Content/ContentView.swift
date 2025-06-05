import SwiftUI

struct ContentView: View {

    @State private var selectedTab: Tab = .breeds
    @Bindable private var coordinator = Coordinator()

    let contentViewModel = ContentViewModel(repository: RepositoryBuilder.makeRepository(api: APIClient()))

    enum Tab {
        case breeds
        case favorites
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                BreedsView(
                    viewModel: BreedsViewModel(
                        contentViewModel: contentViewModel,
                        coordinator: coordinator
                    )
                )
                .navigationTitle(Localized.Breeds.title)
            }
            .tabItem {
                Label(Localized.Breeds.catsListButton, systemImage: Constants.Image.catsList)
            }
            .tag(Tab.breeds)

            NavigationStack {
                FavoritesView(
                    viewModel: FavoritesViewModel(
                        contentViewModel: contentViewModel,
                        coordinator: coordinator
                    )
                )
                .navigationTitle(Localized.Favorites.title)
            }
            .tabItem {
                Label(Localized.Breeds.favouritesButton, systemImage: Constants.Image.favorites)
            }
            .tag(Tab.favorites)
        }
        .sheet(item: $coordinator.presentedBreedDetails) { breed in
            BreedDetailsView(viewModel: BreedDetailsViewModel(breed: breed))
                .navigationTitle(breed.name)
        }
    }
}

// MARK: Preview

#if targetEnvironment(simulator)
#Preview {
    ContentView()
}
#endif
