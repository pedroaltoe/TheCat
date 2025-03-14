import Foundation

struct Breed: Decodable, Identifiable {
    let id: String
    let image: BreedImage?
    let name: String
    var isFavorite: Bool?
}

struct BreedImage: Decodable {
    let url: String
}

#if targetEnvironment(simulator)
extension Breed {
    static let mockBreeds: [Breed] = [
        Breed(
            id: "abys",
            image: nil,
            name: "Abyssinian",
            isFavorite: false
        ),
        Breed(
            id: "aege",
            image: nil,
            name: "Aegean",
            isFavorite: false
        ),
        Breed(
            id: "abob",
            image: nil,
            name: "American Bobtail",
            isFavorite: false
        )
    ]
}
#endif
