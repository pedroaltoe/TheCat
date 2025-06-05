import Observation
import SwiftUI

@MainActor
@Observable
final class BreedDetailsViewModel {

    private(set) var viewState: BreedDetailsViewState

    let contentViewModel: ContentViewModel

    // MARK: Init

    init(
        breed: Breed,
        contentViewModel: ContentViewModel
    ) {
        viewState = .initial
        self.contentViewModel = contentViewModel

        viewState = .present(breed)
    }

    // MARK: Helper

    func toggleFavorite(imageId: String?) async {
        try? await contentViewModel.toggleFavorite(imageId: imageId)
    }

    func isBreedFavorite(imageId: String?) -> Bool {
        return contentViewModel.isFavorite(imageId: imageId)
    }
}
