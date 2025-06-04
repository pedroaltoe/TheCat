import struct Combine.AnyPublisher
import struct Combine.Fail
import struct Combine.Just
import Foundation

protocol RepositoryProtocol {
    var fetchBreeds: (_ page: Int) async throws -> [Breed] { get }
    var fetchFavorites: () async throws -> [Favorite] { get }
    var searchBreeds: (_ query: String) async throws -> [Breed] { get }
    var postFavorite: (_ favoritePost: FavoritePost) async throws -> FavoriteResponse { get }
    var removeFavorite: (_ imageId: Int) async throws -> FavoriteResponse { get }
}

enum RepositoryError: Error {
    case failure
}

struct Repository: RepositoryProtocol {
    var fetchBreeds: (_ page: Int) async throws -> [Breed]
    var fetchFavorites: () async throws -> [Favorite]
    var searchBreeds: (_ query: String) async throws -> [Breed]
    var postFavorite: (_ favoritePost: FavoritePost) async throws -> FavoriteResponse
    var removeFavorite: (_ imageId: Int) async throws -> FavoriteResponse

    init(
        fetchBreeds: @escaping (_ page: Int) async throws -> [Breed],
        fetchFavorites: @escaping () async throws -> [Favorite],
        searchBreeds: @escaping (_ query: String) async throws -> [Breed],
        postFavorite: @escaping (_ favoritePost: FavoritePost) async throws -> FavoriteResponse,
        removeFavorite: @escaping (_ imageId: Int) async throws -> FavoriteResponse
    ) {
        self.fetchBreeds = fetchBreeds
        self.fetchFavorites = fetchFavorites
        self.searchBreeds = searchBreeds
        self.postFavorite = postFavorite
        self.removeFavorite = removeFavorite
    }
}

#if targetEnvironment(simulator)
struct RepositoryMock: RepositoryProtocol {
    enum MockError: Error {
        case failure
    }

    var shouldReturnError = false

    var fetchBreeds: (_ page: Int) async throws -> [Breed] {
        return mockFetchBreeds(_:)
    }

    var fetchFavorites: () async throws -> [Favorite] {
        return mockFetchFavorites
    }

    var searchBreeds: (String) async throws -> [Breed]

    var postFavorite: (FavoritePost) async throws -> FavoriteResponse {
        return mockPostFavorite(_:)
    }

    var removeFavorite: (Int) async throws -> FavoriteResponse {
        return mockRemoveFavorite(_:)
    }

    // MARK: Helpers

    private func mockFetchBreeds(_ page: Int) async throws -> [Breed] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Breed.mockBreeds
    }

    private func mockFetchFavorites() async throws -> [Favorite] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Favorite.mockFavorites
    }

    private func mockSearchBreeds(_ query: String) async throws -> [Breed] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Breed.mockBreeds.filter { $0.name.lowercased().contains(query.lowercased()) }
    }

    private func mockPostFavorite(_ favoritePost: FavoritePost) async throws -> FavoriteResponse {
        if shouldReturnError {
            throw MockError.failure
        }

        return FavoriteResponse.mockSuccessResponse
    }

    private func mockRemoveFavorite(_ imageId: Int) async throws -> FavoriteResponse {
        if shouldReturnError {
            throw MockError.failure
        }

        return FavoriteResponse.mockSuccessResponse
    }
}
#endif
