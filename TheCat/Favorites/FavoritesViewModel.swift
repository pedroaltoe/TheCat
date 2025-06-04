import Observation
import SwiftUI

@MainActor
@Observable
final class FavoritesViewModel {

    private(set) var viewState: FavoritesViewState
    private let contentViewModel: ContentViewModel

    var isLoading = false
    var favoriteBreeds: [BreedDisplayModel] = []

    // MARK: Init

    init(contentViewModel: ContentViewModel) {
        viewState = .initial
        self.contentViewModel = contentViewModel
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
}
