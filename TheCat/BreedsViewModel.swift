import class Combine.AnyCancellable
import SwiftUI

final class BreedsViewModel: ObservableObject {

    @Published private(set) var viewState: BreedsViewState
    
    var breeds: [Breed] = []
    let repository: RepositoryProtocol
    
    init() {
    private var cancellable: AnyCancellable?
        viewState = .initial
        repository = Repository()
    }

    @MainActor
    func fetchBreeds() {
        viewState = .loading
        cancellable = repository.fetchBreeds()
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.viewState = .error(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] value in
                self?.viewState = .loaded(value)
            }
    }
}
