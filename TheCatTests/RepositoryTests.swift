import class Combine.AnyCancellable
@testable import TheCat
import XCTest

final class RepositoryTests: XCTestCase {
    
    private var repository: Repository!
    private var apiClientMock: APIClientMock!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        apiClientMock = APIClientMock()
        repository = RepositoryBuilder.makeRepository(api: apiClientMock)
        cancellables = Set()
    }
    
    override func tearDown() {
        repository = nil
        apiClientMock = nil
        cancellables = nil
    }
    
        // given
        apiClientMock.shouldReturnError = false
        
        let expectation = self.expectation(description: "Fetch users succeeds")
        
        // when
        repository.fetchBreeds()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { breeds in
                // then
                XCTAssertEqual(breeds.count, 3)
                XCTAssertEqual(breeds[0].name, "Abyssinian")
                XCTAssertEqual(breeds[1].name, "Aegean")
                XCTAssertEqual(breeds[2].name, "American Bobtail")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    

    func testFetchBreedsFailure() {
        // given
        apiClientMock.shouldReturnError = true
        
        let expectation = self.expectation(description: "Fetch users fails")
        
        // when
        apiClientMock.fetchBreeds()
            .sink(receiveCompletion: { completion in
                // then
                switch completion {
                case .finished:
                    XCTFail("Expected failure")
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, APIClientMock.MockError.failure.localizedDescription)
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Expected failure")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
}
