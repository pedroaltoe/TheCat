import SwiftUI

@Observable
class Coordinator {

    // MARK: Route

    enum Route: Hashable {
        case contentView
        case detailsView(Breed)
    }

    var path = NavigationPath()

    // MARK: Navigation

    func navigate(to route: Route) {
        path.append(route)
    }

    func goBack() {
        path = NavigationPath()
    }

    // MARK: Screen builder

    @MainActor
    @ViewBuilder
    func build(screen: Route) -> some View {
        let api = APIClient()
        let repository = RepositoryBuilder.makeRepository(api: api)
        let contentViewModel = ContentViewModel(repository: repository)

        switch screen {
        case .contentView:
            ContentView(viewModel: contentViewModel)
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
