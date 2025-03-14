import struct Combine.AnyPublisher
import struct Combine.Fail
import struct Combine.Just
import Foundation

enum RepositoryError: Error {
    case failure
}

struct Repository {
    var fetchBreeds: () -> AnyPublisher<[Breed], Error>

    init(fetchBreeds: @escaping () -> AnyPublisher<[Breed], Error>) {
        self.fetchBreeds = fetchBreeds
    }
}

#if targetEnvironment(simulator)
extension Repository {

    static func mock(fetchBreeds: (() -> AnyPublisher<[Breed], Error>)? = nil) -> Repository {
        Repository(
            fetchBreeds: fetchBreeds ?? {
                Fail(error: URLError(.badServerResponse))
                    .eraseToAnyPublisher()
            }
        )
    }
}
#endif
