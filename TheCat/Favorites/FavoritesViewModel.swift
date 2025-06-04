import Combine
import Observation
import SwiftUI

@MainActor
@Observable
final class FavoritesViewModel {

    private(set) var viewState: FavoritesViewState
    private let contentViewModel: ContentViewModel
    private let coordinator: Coordinator

    private var cancellables = Set<AnyCancellable>()

    // MARK: Init

    init(
        contentViewModel: ContentViewModel,
        coordinator: Coordinator
    ) {
        viewState = .initial
        self.contentViewModel = contentViewModel
        self.coordinator = coordinator

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

    // MARK: Navigation

    func navigateToDetail(for breed: Breed) {
        coordinator.presentedBreedDetails = breed
    }

    // MARK: Helper

    func toggleFavorite(imageId: String?) async {
        try? await contentViewModel.toggleFavorite(imageId: imageId)
    }

    private func updateBreedFavoriteStatus() {
        viewState = .present(contentViewModel.favoriteBreeds)
    }
}
