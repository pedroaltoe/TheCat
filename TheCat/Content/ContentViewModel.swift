import Observation
import SwiftUI

@MainActor
@Observable
final class ContentViewModel {

    private let repository: RepositoryProtocol

    var allBreeds: [BreedDisplayModel] = []
    var filteredBreeds: [BreedDisplayModel] = []
    var favoriteImageIds: Set<String> = []
    var favoriteBreeds: [BreedDisplayModel] = []

    // MARK: Init

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Fetch data

    func fetchBreeds(_ page: Int) async throws -> [BreedDisplayModel] {
        try? await fetchFavorites()
        
        let breeds = try await repository.fetchBreeds(page)
        let displayModel = makeDisplayModel(from: breeds)
        allBreeds.append(contentsOf: displayModel)
        return displayModel
    }

    func searchBreeds(_ query: String) async throws -> [BreedDisplayModel] {
        let breeds = try await repository.searchBreeds(query)
        let displayModel = makeDisplayModel(from: breeds)
        filteredBreeds.append(contentsOf: displayModel)
        return displayModel
    }

    func fetchFavorites() async throws {
        let favorites = try await repository.fetchFavorites()
        favoriteImageIds = Set(favorites.compactMap { $0.imageId })
        favoriteBreeds = filterFavoriteBreeds()
    }

    // MARK: Helper

    private func makeDisplayModel(from breeds: [Breed]) -> [BreedDisplayModel] {
        breeds.map {
            BreedDisplayModel(
                id: $0.referenceImageId ?? "\($0.id)",
                name: $0.name,
                imageUrl: $0.image?.url,
                lifeSpan: $0.lifeSpan
            )
        }
    }

    func filterFavoriteBreeds() -> [BreedDisplayModel] {
        allBreeds.filter { isFavorite($0.id) }
    }

    func isFavorite(_ imageId: String?) -> Bool {
        guard let imageId else { return false }
        return favoriteImageIds.contains(imageId)
    }

    func toggleFavorite(_ imageId: String) async throws {
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
