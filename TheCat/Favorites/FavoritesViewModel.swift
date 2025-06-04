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

    func onAppear() {
        let favorites = contentViewModel.favoriteBreeds

        if favorites.isEmpty {
            viewState = .empty
        } else {
            viewState = .present(favorites)
        }
    }

    // MARK: Helper

    func toggleFavorite(_ breed: BreedDisplayModel) async {
        do {
            try await contentViewModel.toggleFavorite(breed.id)
        } catch {
            print("Failed to toggle favorite")
        }
    }
}
