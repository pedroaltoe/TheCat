import Combine
import Observation
import SwiftUI

@MainActor
@Observable
final class FavoritesViewModel {

    private(set) var viewState: FavoritesViewState
    private let contentViewModel: ContentViewModel

    private var cancellables = Set<AnyCancellable>()

    var isLoading = false
    var favoriteBreeds: [BreedDisplayModel] = []

    // MARK: Init

    init(contentViewModel: ContentViewModel) {
        viewState = .initial
        self.contentViewModel = contentViewModel

        setupFavouriteObserver()
    }

    // MARK: Setup

    private func setupFavouriteObserver() {
        contentViewModel.favoritesChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateBreedFavoriteStatus()
            }
            .store(in: &cancellables)
    }

    // MARK: Fetch data

    func checkFavorites() {
        let favorites = contentViewModel.favoriteBreeds

        if favorites.isEmpty {
            viewState = .empty
        } else {
            viewState = .present(favorites)
        }
    }

    // MARK: Helper

    func toggleFavorite(_ imageId: String) async {
        try? await contentViewModel.toggleFavorite(imageId)
    }

    private func updateBreedFavoriteStatus() {
        guard case .present(let favoriteBreeds) = viewState else { return }
        viewState = .present(favoriteBreeds)
    }
}
