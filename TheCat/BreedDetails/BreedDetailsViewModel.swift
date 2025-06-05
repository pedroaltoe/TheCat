import Observation
import SwiftUI

@MainActor
@Observable
final class BreedDetailsViewModel {

    let breed: Breed
    let contentViewModel: ContentViewModel

    // MARK: Init

    init(
        breed: Breed,
        contentViewModel: ContentViewModel
    ) {
        self.breed = breed
        self.contentViewModel = contentViewModel
    }

    // MARK: Helper

    func toggleFavorite(imageId: String?) async {
        try? await contentViewModel.toggleFavorite(imageId: imageId)
    }

    func isBreedFavorite(imageId: String?) -> Bool {
        return contentViewModel.isFavorite(imageId: imageId)
    }
}
