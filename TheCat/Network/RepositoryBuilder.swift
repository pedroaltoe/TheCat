import Foundation

struct RepositoryBuilder {
    static func makeRepository(api: APIClientProtocol)
    -> Repository {
        Repository {
            api.fetchBreeds()
        }
    }
}
