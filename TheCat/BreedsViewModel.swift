import class Combine.AnyCancellable
import SwiftUI

final class BreedsViewModel: ObservableObject {

    @Published private(set) var viewState: BreedsViewState
    
    @Published var searchText = ""

    @Published var isLoadingMore = false

    private var breeds: [Breed] = []
    private var filteredBreeds: [Breed] = []
    private var page = 0
    private var cancellables = Set<AnyCancellable>()

    private let repository: Repository

    // MARK: Init

    init(repository: Repository = RepositoryBuilder.makeRepository(api: APIClient())) {
        viewState = .initial
        self.repository = repository

        setUpObservers()
    }

    // MARK: Fetch data

    @MainActor func fetchBreeds(_ page: Int = 0) {
        repository.fetchBreeds(page)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.viewState = .error(error.localizedDescription)
                case .finished:
                    self?.searchText = ""
                    self?.isLoadingMore = false
                    break
                }
            } receiveValue: { [weak self] value in
                guard let self, !value.isEmpty else { return }
                if page > 0 {
                    breeds.append(contentsOf: value)
                } else {
                    breeds = value
                }
                viewState = .present(breeds)
                filteredBreeds = breeds
            }
            .store(in: &cancellables)
    }

    @MainActor func refreshBreeds() {
        page = 0
        fetchBreeds()
    }

    @MainActor func fetchMoreBreeds(from lastBreedId: String) {
        guard lastBreedId == breeds.last?.id else { return }
        isLoadingMore = true
        page += 1
        fetchBreeds(page)
    }

    // MARK: Funcs

    private func setUpObservers() {
        $searchText
            .dropFirst()
            .sink { [weak self] text in
                self?.filterBreeds(text)
            }
            .store(in: &cancellables)
    }

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
