import Foundation

struct RepositoryBuilder {
    static func makeRepository(api: APIClientProtocol)
    -> Repository {
        Repository { page in
            try await api.fetchBreeds(page)
        } fetchFavourites: {
            try await api.fetchFavourites()
        }

    }
}
