@testable import TheCat
import XCTest

final class MyViewModelTests: XCTestCase {

    @MainActor
    func testFetchBreedsFailure() async {
        // given
        let viewModel = await makeViewModel(makeFailureRepositoryMock())

        // when
        await viewModel.fetchBreeds()

        // then
        guard case .error = viewModel.viewState else {
            XCTFail("Expected viewState to be '.error'!")
            return
        }
    }

    @MainActor
    func testFetchBreedsSuccess() async {
        // given
        let viewModel = await makeViewModel()

        // when
        await viewModel.fetchBreeds()

        // then
        guard case .present = viewModel.viewState else {
            XCTFail("Expected viewState to be '.present'!")
            return
        }
    }

    @MainActor
    func testFilterBreeds() async {
        // given
        let viewModel = await makeViewModel()

        // when
        await viewModel.fetchBreeds()
        viewModel.searchText = "ae"

        // then
        guard case let .present(breeds) = viewModel.viewState else {
            XCTFail("Expected viewState to be '.present'!")
            return
        }

        XCTAssertEqual(breeds.first?.name, "Aegean")
    }

    // MARK: Helpers

    @MainActor
    private func makeViewModel(_ repository: RepositoryProtocol = RepositoryMock()) async -> BreedsViewModel {
        return BreedsViewModel(repository: repository)
    }

    private func makeFailureRepositoryMock() -> RepositoryMock {
        RepositoryMock(shouldReturnError: true)
    }
}
