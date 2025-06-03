import Observation
import SwiftUI

@MainActor
@Observable
final class ContentViewModel {

    private let repository: RepositoryProtocol

    var allBreeds: [BreedDisplayModel] = []
    var favoriteImageIds: Set<String> = []

    // MARK: Init

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Fetch data

    func fetchBreeds(_ page: Int) async throws -> [BreedDisplayModel] {
        let breeds = try await repository.fetchBreeds(page)
        let displayModel = makeDisplayModel(from: breeds)
        allBreeds.append(contentsOf: displayModel)
        return displayModel
    }

    func fetchFavorites() async throws {
        let favorites = try await repository.fetchFavorites()
        favoriteImageIds = Set(favorites.compactMap { $0.imageId })
    }

    func onAppear() {
        Task {
            try await fetchFavorites()
        }
    }

    // MARK: Helper

    private func makeDisplayModel(from breeds: [Breed]) -> [BreedDisplayModel] {
        breeds.map {
            BreedDisplayModel(
                id: $0.referenceImageId ?? "\($0.id)",
                name: $0.name,
                imageUrl: $0.image?.url,
                lifeSpan: $0.lifeSpan,
                isFavorite: isFavorite($0.referenceImageId)
            )
        }
    }

    func isFavorite(_ imageId: String?) -> Bool {
        guard let imageId else { return false }
        return favoriteImageIds.contains(imageId)
    }

    func toggleFavorite(_ imageId: String?) async throws {
        guard let imageId else { return }
        let favoritePost = FavoritePost(imageId: imageId)

        if isFavorite(imageId) {
//            try await api.unfavorite(imageId)
            favoriteImageIds.remove(imageId)
        } else {
            // TODO: Handle error
            let response = try await repository.postFavorite(favoritePost)
            favoriteImageIds.insert(imageId)
        }
    }
}
