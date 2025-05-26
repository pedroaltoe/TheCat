import Observation
import SwiftUI

@Observable
final class BreedDetailsViewModel {

    var breed: Breed

    init(breed: Breed) {
        self.breed = breed
    }
}
