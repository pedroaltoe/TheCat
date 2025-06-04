import SwiftUI

@MainActor
@Observable
class Coordinator {

    // MARK: Route

    enum Route: Hashable {
        case breedsView
        case favoritesView
        case detailsView(Breed)
    }

    let contentViewModel: ContentViewModel

    var path = NavigationPath()

    init() {
        let api = APIClient()
        let repository = RepositoryBuilder.makeRepository(api: api)
        contentViewModel = ContentViewModel(repository: repository)
    }

    // MARK: Navigation

    func navigate(to route: Route) {
        path.append(route)
    }

    func goBack() {
        path = NavigationPath()
    }

    // MARK: Screen builder

    @ViewBuilder
    func build(screen: Route) -> some View {
        switch screen {
        case .breedsView:
            BreedsView(viewModel: BreedsViewModel(contentViewModel: contentViewModel))
                .navigationTitle(Localized.Breeds.title)
        case .favoritesView:
            FavoritesView(viewModel: FavoritesViewModel(contentViewModel: contentViewModel))
                .navigationTitle(Localized.Favorites.title)
        case let .detailsView(breed):
            BreedDetailsView(viewModel: BreedDetailsViewModel(breed: breed))
        }
    }
}

#if targetEnvironment(simulator)
final class MockCoordinator: Coordinator {

    var didNavigateBack = false

    var lastRoute: Route?

    override func navigate(to route: Route) {
        lastRoute = route
    }

    override func goBack() {
        didNavigateBack = true
    }
}
#endif
