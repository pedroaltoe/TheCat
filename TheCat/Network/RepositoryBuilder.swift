import Foundation

struct RepositoryBuilder {
    static func makeRepository(api: APIClientProtocol)
    -> Repository {
        Repository { page in
            api.fetchBreeds(page)
        } fetchFavourites: {
            api.fetchFavourites()
        }

    }
}
