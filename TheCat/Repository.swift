import Foundation

protocol RepositoryProtocol {
    func fetchBreeds() async throws -> [Breed]
}

final class Repository: RepositoryProtocol {
    
    func fetchBreeds() async throws -> [Breed] {
        let endpoint = "https://api.thecatapi.com/v1/breeds" //?limit=10&page=0
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(
            "live_HUApwD4JQqYgPtRXO0P0tyNfolxiKv9yn4lWb5BFF3zdiRvaDQCmZ8n6SNtDsAG2",
            forHTTPHeaderField: "x-api-key"
        )
        
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
}

