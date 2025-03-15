import struct Combine.AnyPublisher
import struct Combine.Fail
import struct Combine.Just
import Foundation

protocol APIClientProtocol {
    func fetchBreeds(_ page: Int) -> AnyPublisher<[Breed], Error>
    func fetchFavourites() -> AnyPublisher<[Breed], Error>
}

enum APIEndpoint {
    private static let baseURL = "https://api.thecatapi.com/v1"

    case getBreeds(page: Int)
    case getFavourites

    var url: String {
        switch self {
        case let .getBreeds(page): return "\(Self.baseURL)/breeds?limit=15&page=\(page)"
        case .getFavourites: return "\(Self.baseURL)/favourites"
        }
    }
}

final class APIClient: APIClientProtocol {
    
    func fetchBreeds(_ page: Int) -> AnyPublisher<[Breed], Error> {
        guard let url = URL(string: APIEndpoint.getBreeds(page: page).url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = setupHeaders()
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: [Breed].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchFavourites() -> AnyPublisher<[Breed], Error> {
        guard let url = URL(string: APIEndpoint.getFavourites.url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = setupHeaders()

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: [Breed].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers

    private func setupHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["x-api-key"] = "live_HUApwD4JQqYgPtRXO0P0tyNfolxiKv9yn4lWb5BFF3zdiRvaDQCmZ8n6SNtDsAG2"
        return headers
    }
}

#if targetEnvironment(simulator)
struct APIClientMock: APIClientProtocol {
    enum MockError: Error {
        case failure
    }
    
    var shouldReturnError = false

    func fetchBreeds(_ page: Int) -> AnyPublisher<[Breed], Error> {
        if shouldReturnError {
            return Fail(error: APIClientMock.MockError.failure)
                .eraseToAnyPublisher()
        }
        
        return Just(Breed.mockBreeds)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchFavourites() -> AnyPublisher<[Breed], Error> {
        if shouldReturnError {
            return Fail(error: APIClientMock.MockError.failure)
                .eraseToAnyPublisher()
        }

        return Just(Breed.mockBreeds)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
#endif
