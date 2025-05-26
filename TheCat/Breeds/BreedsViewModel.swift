import Observation
import SwiftUI

@MainActor
@Observable
final class BreedsViewModel {

    private(set) var viewState: BreedsViewState
    
    var searchText = "" {
        didSet {
            filterBreeds(searchText)
        }
    }

    var isLoadingMore = false

    private var breeds: [Breed] = []
    private var filteredBreeds: [Breed] = []
    private var favourites: [Breed] = []
    private var page = 0

    private let repository: RepositoryProtocol

    // MARK: Init

    init(repository: RepositoryProtocol = RepositoryBuilder.makeRepository(api: APIClient())) {
        viewState = .initial
        self.repository = repository
    }

    // MARK: Fetch data

    func fetchFavourites() async {
        do {
            let favourites = try await repository.fetchFavourites()
            viewState = .present(favourites)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    func fetchBreeds(_ page: Int = 0) async {
        do {
            let breeds = try await repository.fetchBreeds(page)

            guard !breeds.isEmpty else {
                isLoadingMore = false
                return
            }

            if page > 0 {
                self.breeds.append(contentsOf: breeds)
            } else {
                self.breeds = breeds
            }

            viewState = .present(self.breeds)
            filteredBreeds = self.breeds
        } catch {
            viewState = .error(error.localizedDescription)
        }

        isLoadingMore = false
    }

    func fetchMoreBreeds(from lastBreedId: String) {
        guard lastBreedId == breeds.last?.id else { return }
        isLoadingMore = true
        page += 1

        Task {
            await fetchBreeds(page)
        }
    }

    func onAppear() {
        page = 0
        Task {
            await fetchBreeds()
        }
    }

    func onRefresh() {
        page = 0
        Task {
            await fetchBreeds()
        }
    }

    // MARK: Search

    private func filterBreeds(_ text: String) {
        if text.isEmpty {
            filteredBreeds = breeds
        } else {
            filteredBreeds = breeds.filter {
                $0.name.localizedStandardContains(text)
            }
        }

        viewState = .present(filteredBreeds)
    }
}
