import Foundation

struct Breed: Decodable, Equatable, Hashable, Identifiable {
    let id: String
    let image: BreedImage?
    let name: String
    let temperament: String
    let origin: String
    let description: String
    let referenceImageId: String?
    let lifeSpan: String
}

struct BreedImage: Decodable, Hashable, Equatable {
    let url: String
}

#if targetEnvironment(simulator)
extension Breed {
    static let mockBreeds: [Breed] = [
        Breed(
            id: "abys",
            image: nil,
            name: "Abyssinian",
            temperament: "Active, Energetic, Independent, Intelligent, Gentle",
            origin: "Egypt",
            description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
            referenceImageId: "abys",
            lifeSpan: "14 - 15"
        ),
        Breed(
            id: "aege",
            image: nil,
            name: "Aegean",
            temperament: "Affectionate, Social, Intelligent, Playful, Active",
            origin: "Greece",
            description: "Native to the Greek islands known as the Cyclades in the Aegean Sea, these are natural cats, meaning they developed without humans getting involved in their breeding. As a breed, Aegean Cats are rare, although they are numerous on their home islands. They are generally friendly toward people and can be excellent cats for families with children.",
            referenceImageId: "aege",
            lifeSpan: "9 - 12"
        ),
        Breed(
            id: "abob",
            image: nil,
            name: "American Bobtail",
            temperament: "Intelligent, Interactive, Lively, Playful, Sensitive",
            origin: "United States",
            description: "American Bobtails are loving and incredibly intelligent cats possessing a distinctive wild appearance. They are extremely interactive cats that bond with their human family with great devotion.",
            referenceImageId: "abob",
            lifeSpan: "11 - 15"
        )
    ]
}
#endif
