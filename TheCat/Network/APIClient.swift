import struct Combine.AnyPublisher
import struct Combine.Fail
import struct Combine.Just
import Foundation

protocol APIClientProtocol {
    func fetchBreeds(_ page: Int) async throws -> [Breed]
    func fetchFavourites()  async throws -> [Breed]
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
    
    func fetchBreeds(_ page: Int)  async throws -> [Breed] {
        return try await fetch(.getBreeds(page: page))
    }

    func fetchFavourites() async throws -> [Breed] {
        return try await fetch(.getFavourites)
    }

    private func fetch(_ endpoint: APIEndpoint) async throws -> [Breed] {
        let url: URL?
        switch endpoint {
        case let .getBreeds(page):
            url = URL(string: APIEndpoint.getBreeds(page: page).url)
        case .getFavourites:
            url = URL(string: APIEndpoint.getFavourites.url)
        }

        guard let url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = setupHeaders()

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 else
        {
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Breed].self, from: data)
        } catch {
            throw URLError(.cannotDecodeRawData)
        }
    }

    // MARK: - Helpers

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

    func fetchBreeds(_ page: Int) async throws -> [Breed] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Breed.mockBreeds
    }

    func fetchFavourites() async throws -> [Breed] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Breed.mockBreeds
    }
}
#endif
