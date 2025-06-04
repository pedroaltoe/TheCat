import SwiftUI

@MainActor
@Observable
class Coordinator {

    // MARK: Route

    enum Route: Hashable {
        case breedsView
        case favoritesView
    }

    let contentViewModel: ContentViewModel

    var path = NavigationPath()

    var presentedBreedDetails: Breed?

    init() {
        let api = APIClient()
        let repository = RepositoryBuilder.makeRepository(api: api)
        contentViewModel = ContentViewModel(repository: repository)
    }

    // MARK: Navigation

    func navigate(to route: Route) {
        switch route {
        case .breedsView:
            path.append(route)
        case .favoritesView:
            path.append(route)
        }
    }

    func goBack() {
        if presentedBreedDetails != nil {
            presentedBreedDetails = nil
        } else if !path.isEmpty {
            path.removeLast()
        } else {
            path = NavigationPath()
        }
    }

    func dismissModal() {
        presentedBreedDetails = nil
    }

    // MARK: Main screen builder

    @ViewBuilder
    func build(screen: Route) -> some View {
        switch screen {
        case .breedsView:
            BreedsView(
                viewModel: BreedsViewModel(
                    contentViewModel: contentViewModel,
                    coordinator: self
                )
            )
            .navigationTitle(Localized.Breeds.title)
        case .favoritesView:
            FavoritesView(
                viewModel: FavoritesViewModel(
                    contentViewModel: contentViewModel,
                    coordinator: self
                )
            )
            .navigationTitle(Localized.Favorites.title)
        }
    }

    // MARK: Detail screen builder
    @ViewBuilder
    func buildBreedDetailsView(breed: Breed) -> some View {
        NavigationStack {
            BreedDetailsView(viewModel: BreedDetailsViewModel(breed: breed))
                .navigationTitle(breed.name)
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
