import Combine
@testable import TheCat
import XCTest

class MyViewModelTests: XCTestCase {

    var viewModel: BreedsViewModel!
    var mockRepository: Repository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = Repository.mock()
        viewModel = BreedsViewModel(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    @MainActor func testFetchBreedsFailure() {
        // given
        let expectation = expectation(description: "Wait for main thread sink")
        var expectedViewState: BreedsViewState?

        // when
        viewModel.$viewState
            .dropFirst()
            .sink {
                expectedViewState = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchBreeds()

        wait(for: [expectation], timeout: 1.0)

        // then
        guard case .error = expectedViewState else {
            XCTFail("Expected viewState to be '.error'!")
            return
        }
    }

    @MainActor func testFetchBreedsSuccess() {
        // given
        let expectation = expectation(description: "Wait for main thread sink")
        expectation.expectedFulfillmentCount = 2
        var expectedViewState: BreedsViewState?
        let viewModel = makeViewModelWithSuccessRepository()

        // when
        viewModel.$viewState
            .dropFirst()
            .sink {
                expectedViewState = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchBreeds()

        wait(for: [expectation], timeout: 1.0)

        // then
        guard case .present = expectedViewState else {
            XCTFail("Expected viewState to be '.present'!")
            return
        }
    }

    @MainActor func testFilterBreeds() {
        // given
        let expectation = expectation(description: "Wait for main thread sink")
        expectation.expectedFulfillmentCount = 3
        var expectedViewState: BreedsViewState?
        let viewModel = makeViewModelWithSuccessRepository()

        // when
        viewModel.$viewState
            .dropFirst()
            .sink {
                expectedViewState = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchBreeds()
        viewModel.searchText = "ae"

        wait(for: [expectation], timeout: 1.0)

        // then
        guard case let .present(breeds) = expectedViewState else {
            XCTFail("Expected viewState to be '.present'!")
            return
        }

        XCTAssertEqual(breeds.first?.name, "Aegean")
    }

    // MARK: Helpers

    private func makeViewModelWithSuccessRepository() -> BreedsViewModel {
        let successRepository = Repository.mock { _ in 
            Just(Breed.mockBreeds).setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return BreedsViewModel(repository: successRepository)
    }
}
