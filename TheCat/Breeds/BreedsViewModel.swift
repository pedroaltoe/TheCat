import Combine
import Observation
import SwiftUI

@MainActor
@Observable
final class BreedsViewModel {

    private(set) var viewState: BreedsViewState
    
    var searchText = "" {
        didSet {
            debouncedSearchTextSubject.send(searchText)
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private let debouncedSearchTextSubject = PassthroughSubject<String, Never>()
    private var currentTask: Task<Void, Never>?

    var isLoadingMore = false

    private var breeds: [BreedDisplayModel] = []
    private var filteredBreeds: [BreedDisplayModel] = []
    private var page = 0

    private let contentViewModel: ContentViewModel

    // MARK: Init

    init(contentViewModel: ContentViewModel) {
        viewState = .initial
        self.contentViewModel = contentViewModel

        setupFavouriteObserver()
        setupDebouncedSearch()
    }

    // MARK: Setup

    private func setupFavouriteObserver() {
        contentViewModel.favoritesChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateBreedFavoriteStatus()
            }
            .store(in: &cancellables)
    }

    private func setupDebouncedSearch() {
        debouncedSearchTextSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchBreeds(searchText)
            }
            .store(in: &cancellables)
    }

    // MARK: Fetch data

    func fetchBreeds(_ page: Int = 0) async {
        do {
            let breeds = try await contentViewModel.fetchBreeds(page)

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

    func searchBreeds(_ query: String) {
        currentTask?.cancel()
        currentTask = Task {
            do {
                guard !query.isEmpty else {
                    self.filteredBreeds = self.breeds
                    viewState = .present(self.filteredBreeds)
                    return
                }

                page = 0
                isLoadingMore = false

                let filteredBreeds = try await contentViewModel.searchBreeds(query)
                self.filteredBreeds = filteredBreeds
                viewState = .present(self.filteredBreeds)
            } catch {
                viewState = .error(error.localizedDescription)
            }
        }
    }

    // MARK: Helper

    func toggleFavorite(_ imageId: String) async {
        try? await contentViewModel.toggleFavorite(imageId)
    }

    func isBreedFavorite(_ breedId: String) -> Bool {
        return contentViewModel.isFavorite(breedId)
    }

    private func updateBreedFavoriteStatus() {
        guard case .present(let currentBreeds) = viewState else { return }
        viewState = .present(currentBreeds)
    }
}
