import struct Combine.AnyPublisher
import struct Combine.Fail
import struct Combine.Just
import Foundation

protocol RepositoryProtocol {
    var fetchBreeds: (_ page: Int) async throws -> [Breed] { get }
    var fetchFavourites: () async throws -> [Breed] { get }
}

enum RepositoryError: Error {
    case failure
}

struct Repository: RepositoryProtocol {
    var fetchBreeds: (_ page: Int) async throws -> [Breed]
    var fetchFavourites: () async throws -> [Breed]

    init(
        fetchBreeds: @escaping (_ page: Int) async throws -> [Breed],
        fetchFavourites: @escaping () async throws -> [Breed]
    ) {
        self.fetchBreeds = fetchBreeds
        self.fetchFavourites = fetchFavourites
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

    var fetchFavourites: () async throws -> [Breed] {
        return mockFetchFavourites
    }

    // MARK: Helpers

    private func mockFetchBreeds(_ page: Int) async throws -> [Breed] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Breed.mockBreeds
    }

    private func mockFetchFavourites() async throws -> [Breed] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Breed.mockBreeds
    }
}
#endif
