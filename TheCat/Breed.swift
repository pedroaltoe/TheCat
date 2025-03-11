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
