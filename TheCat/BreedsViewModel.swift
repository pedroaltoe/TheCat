import class Combine.AnyCancellable
import SwiftUI

final class BreedsViewModel: ObservableObject {

    @Published private(set) var viewState: BreedsViewState

    private var cancellable: AnyCancellable?

    let repository: Repository

    init(repository: Repository = RepositoryBuilder.makeRepository(api: APIClient())) {
        viewState = .initial
        self.repository = repository
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
                self?.viewState = .present(value)
            }
    }
}
