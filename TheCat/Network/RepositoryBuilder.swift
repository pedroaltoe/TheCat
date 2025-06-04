import Foundation

struct RepositoryBuilder {
    static func makeRepository(api: APIClientProtocol)
    -> Repository {
        Repository { page in
            try await api.fetchBreeds(page)
        } fetchFavorites: {
            try await api.fetchFavorites()
        } searchBreeds: { query in
            try await api.searchBreeds(query)
        } postFavorite: { favorite in
            try await api.postFavorite(favorite)
        }
    }
}
