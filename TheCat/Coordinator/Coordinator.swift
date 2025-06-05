import SwiftUI

@Observable
class Coordinator {

    var presentedBreedDetails: Breed?

    // MARK: Navigation

    func goBack() {
        if presentedBreedDetails != nil {
            presentedBreedDetails = nil
        }
    }

    func dismissModal() {
        presentedBreedDetails = nil
    }
}

#if targetEnvironment(simulator)
final class MockCoordinator: Coordinator {

    func navigateToBreedDetails(_ breed: Breed) {
        presentedBreedDetails = breed
    }
}
#endif
