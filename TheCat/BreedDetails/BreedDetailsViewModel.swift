import SwiftUI

final class BreedDetailsViewModel: ObservableObject {

    var breed: Breed

    init(breed: Breed) {
        self.breed = breed
    }
}
