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
        fetch(from: .getBreeds(page: page))
    }

    func fetchFavourites() -> AnyPublisher<[Breed], Error> {
        fetch(from: .getFavourites)
    }

    // MARK: - Helpers

    private func fetch(from endpoint: APIEndpoint) -> AnyPublisher<[Breed], Error> {
        var url: URL?
        switch endpoint {
        case let .getBreeds(page):
            url = URL(string: APIEndpoint.getBreeds(page: page).url)
        case .getFavourites:
            url = URL(string: APIEndpoint.getFavourites.url)
        }

        guard let url else {
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

    private func setupHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["x-api-key"] = loadAPIKey()
        return headers
    }

    func loadAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["API_KEY"] as? String else { return "" }
        return apiKey
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
