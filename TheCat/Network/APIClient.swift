import struct Combine.AnyPublisher
import struct Combine.Fail
import struct Combine.Just
import Foundation

protocol APIClientProtocol {
    func fetchBreeds(_ page: Int) async throws -> [Breed]
    func fetchFavorites()  async throws -> [Favorite]
    func searchBreeds(_ query: String) async throws -> [Breed]
    func postFavorite(_ favoritePost: FavoritePost)  async throws -> FavoriteResponse
    func removeFavorite(_ imageId: Int)  async throws -> Void
}

enum APIEndpoint {
    private static let baseURL = "https://api.thecatapi.com/v1"

    case getBreeds(page: Int)
    case getFavorites
    case searchBreeds(query: String)
    case postFavorite
    case removeFavorite(imageId: Int)

    var url: String {
        switch self {
        case let .getBreeds(page): return "\(Self.baseURL)/breeds?limit=15&page=\(page)"
        case .getFavorites: return "\(Self.baseURL)/favourites"
        case let .searchBreeds(query): return "\(Self.baseURL)/breeds/search?q=\(query)"
        case .postFavorite: return "\(Self.baseURL)/favourites"
        case let .removeFavorite(imageId): return "\(Self.baseURL)/favourites/\(imageId)"
        }
    }
}

enum HttpMethod: String {
    case post = "POST"
    case delete = "DELETE"
}

final class APIClient: APIClientProtocol {

    // MARK: GET

    func fetchBreeds(_ page: Int)  async throws -> [Breed] {
        return try await fetch(.getBreeds(page: page))
    }

    func fetchFavorites() async throws -> [Favorite] {
        return try await fetch(.getFavorites)
    }

    func searchBreeds(_ query: String) async throws -> [Breed] {
        return try await fetch(.searchBreeds(query: query))
    }

    private func fetch<T: Decodable>(_ endpoint: APIEndpoint) async throws -> [T] {
        var url = URL(string: "")
        switch endpoint {
        case let .getBreeds(page):
            url = URL(string: APIEndpoint.getBreeds(page: page).url)
        case .getFavorites:
            url = URL(string: APIEndpoint.getFavorites.url)
        case let .searchBreeds(query):
            url = URL(string: APIEndpoint.searchBreeds(query: query).url)
        default: break
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
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([T].self, from: data)
        } catch {
            throw URLError(.cannotDecodeRawData)
        }
    }

    // MARK: POST

    func postFavorite(_ favoritePost: FavoritePost)  async throws -> FavoriteResponse {
        guard let url = URL(string: APIEndpoint.postFavorite.url) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.allHTTPHeaderFields = setupHeaders()

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(favoritePost)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 else
        {
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(FavoriteResponse.self, from: data)
        } catch {
            throw URLError(.cannotDecodeRawData)
        }
    }

    // MARK: DELETE

    func removeFavorite(_ imageId: Int)  async throws -> Void {
        guard let url = URL(string: APIEndpoint.removeFavorite(imageId: imageId).url) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.delete.rawValue
        request.allHTTPHeaderFields = setupHeaders()

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 else
        {
            throw URLError(.badServerResponse)
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

    func fetchFavorites() async throws -> [Favorite] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Favorite.mockFavorites
    }

    func searchBreeds(_ query: String) async throws -> [Breed] {
        if shouldReturnError {
            throw MockError.failure
        }

        return Breed.mockBreeds
    }

    func postFavorite(_ favoritePost: FavoritePost)  async throws -> FavoriteResponse {
        if shouldReturnError {
            throw MockError.failure
        }

        return FavoriteResponse.mockSuccessResponse
    }

    func removeFavorite(_ imageId: Int) async throws -> Void {
        if shouldReturnError {
            throw MockError.failure
        }
    }
}
#endif
