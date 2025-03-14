import SwiftUI

final class BreedsViewModel: ObservableObject {

    @Published private(set) var viewState: BreedsViewState
    
    var breeds: [Breed] = []
    let repository: RepositoryProtocol
    
    init() {
        viewState = .initial
        repository = Repository()
    }

    @MainActor
    func fetchBreeds() async {
        viewState = .loading
        do {
            breeds = try await repository.fetchBreeds()
            viewState = .loaded(breeds)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    func refresh() {
        Task {
            await fetchBreeds()
        }
    }
}
