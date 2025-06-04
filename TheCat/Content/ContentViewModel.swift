import Combine
import Foundation
import Observation

@MainActor
@Observable
final class ContentViewModel {

    private let favoritesChangedSubject = PassthroughSubject<Void, Never>()
    var favoritesChangedPublisher: AnyPublisher<Void, Never> {
        favoritesChangedSubject.eraseToAnyPublisher()
    }

    private let repository: RepositoryProtocol

    var allBreeds: [Breed] = []
    var filteredBreeds: [Breed] = []
    var favoriteImageIds: Set<String> = []
    var favoriteBreeds: [Breed] = []
    var allFavorites: [Favorite] = []

    // MARK: Init

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Fetch data

    func fetchBreeds(_ page: Int) async throws -> [Breed] {
        try? await fetchFavorites()
        
        let breeds = try await repository.fetchBreeds(page)
        allBreeds.append(contentsOf: breeds)
        return breeds
    }

    func searchBreeds(_ query: String) async throws -> [Breed] {
        let breeds = try await repository.searchBreeds(query)
        filteredBreeds.append(contentsOf: breeds)
        return breeds
    }

    func fetchFavorites() async throws {
        allFavorites = try await repository.fetchFavorites()
        favoriteImageIds = Set(allFavorites.compactMap { $0.imageId })
        favoriteBreeds = filterFavoriteBreeds()
        favoritesChangedSubject.send(())
    }

    // MARK: Helper

    func filterFavoriteBreeds() -> [Breed] {
        allBreeds.filter { isFavorite(imageId: $0.referenceImageId) }
    }

    func isFavorite(imageId: String?) -> Bool {
        guard let imageId else { return false }
        return favoriteImageIds.contains(imageId)
    }

    func toggleFavorite(imageId: String?) async throws {
        guard let imageId else { return }
        let favoritePost = FavoritePost(imageId: imageId)

        if isFavorite(imageId: imageId) {
            if let favorite = allFavorites.first(where: { $0.imageId == imageId }) {
                let response = try? await repository.removeFavorite(favorite.id)
                print("----- Removed with: \(String(describing: response)) -----")
            }

            favoriteBreeds.removeAll { $0.referenceImageId == imageId }
            favoriteImageIds.remove(imageId)
        } else {
            // TODO: Handle error
            let response = try? await repository.postFavorite(favoritePost)
            print("----- Added with: \(String(describing: response)) -----")
            favoriteImageIds.insert(imageId)
        }

        try? await fetchFavorites()
    }
}
