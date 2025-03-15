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

    @MainActor func testFetchData_Failure() {
        // given
        let expectation = expectation(description: "Wait for main thread sink")
        expectation.expectedFulfillmentCount = 2
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
            XCTFail("expected viewState to be '.error'!")
            return
        }
    }

    @MainActor func testFetchData_Success() {
        // given
        let expectation = expectation(description: "Wait for main thread sink")
        expectation.expectedFulfillmentCount = 2
        var expectedViewState: BreedsViewState?
        let successRepository = Repository.mock {
            Just(Breed.mockBreeds).setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let viewModel = BreedsViewModel(repository: successRepository)

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
            XCTFail("Expected viewState to be '.loaded'!")
            return
        }
    }
}
