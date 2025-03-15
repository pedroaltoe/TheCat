import struct Combine.AnyPublisher
import struct Combine.Fail
import struct Combine.Just
import Foundation

enum RepositoryError: Error {
    case failure
}

struct Repository {
    var fetchBreeds: (_ page: Int) -> AnyPublisher<[Breed], Error>

    init(fetchBreeds: @escaping (_ page: Int) -> AnyPublisher<[Breed], Error>) {
        self.fetchBreeds = fetchBreeds
    }
}

#if targetEnvironment(simulator)
extension Repository {

    static func mock(fetchBreeds: ((_ page: Int) -> AnyPublisher<[Breed], Error>)? = nil) -> Repository {
        Repository(
            fetchBreeds: fetchBreeds ?? { _ in
                Fail(error: URLError(.badServerResponse))
                    .eraseToAnyPublisher()
            }
        )
    }
}
#endif
