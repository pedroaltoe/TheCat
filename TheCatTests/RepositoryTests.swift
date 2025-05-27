@testable import TheCat
import XCTest

final class RepositoryTests: XCTestCase {

    // MARK: Breeds

    func testFetchBreedsSuccess() async {
        // given
        let repository = makeSuccessRepository()

        // when
        guard let breeds = try? await repository.fetchBreeds(0) else {
            XCTFail("Unexpected failure")
            return
        }

        XCTAssertEqual(breeds.count, 3)
        XCTAssertEqual(breeds[0].name, "Abyssinian")
        XCTAssertEqual(breeds[1].name, "Aegean")
        XCTAssertEqual(breeds[2].name, "American Bobtail")
    }

    func testFetchBreedsFailure() async {
        // given
        let repository = makeFailureRepository()

        // when
        do {
            let _ = try await repository.fetchBreeds(0)
        } catch {
            XCTAssertEqual(error as? APIClientMock.MockError, .failure)
        }
    }

    // MARK: Helpers

    private func makeSuccessRepository() -> RepositoryProtocol {
        RepositoryBuilder.makeRepository(api: APIClientMock(shouldReturnError: false))
    }

    private func makeFailureRepository() -> RepositoryProtocol {
        RepositoryBuilder.makeRepository(api: APIClientMock(shouldReturnError: true))
    }
}
