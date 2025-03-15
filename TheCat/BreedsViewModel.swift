import class Combine.AnyCancellable
import SwiftUI

final class BreedsViewModel: ObservableObject {

    @Published private(set) var viewState: BreedsViewState
    
    @Published var searchText = ""

    private var breeds: [Breed] = []
    private var filteredBreeds: [Breed] = []
    private var cancellables = Set<AnyCancellable>()

    let repository: Repository

    // MARK: Init

    init(repository: Repository = RepositoryBuilder.makeRepository(api: APIClient())) {
        viewState = .initial
        self.repository = repository

        setUpObservers()
    }

    // MARK: Fetch data

    @MainActor
    func fetchBreeds() {
        viewState = .loading
        repository.fetchBreeds()
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.viewState = .error(error.localizedDescription)
                case .finished:
                    self?.searchText = ""
                    break
                }
            } receiveValue: { [weak self] value in
                self?.viewState = .present(value)
                self?.breeds = value
                self?.filteredBreeds = value
            }
            .store(in: &cancellables)
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
