import Foundation

struct FavoritePost: Encodable {
    let imageId: String
}

struct Favorite: Codable, Identifiable {
    let id: Int
    let userId: String
    let imageId: String
    let createdAt: String
    let image: FavoriteImage?
}

struct FavoriteImage: Codable {
    let id: String
    let url: String
}

struct FavoriteResponse: Decodable {
    let id: Int
    let message: String
}

#if targetEnvironment(simulator)
extension Favorite {
    static let mockFavorites: [Favorite] = [
        Favorite(
            id: UUID().hashValue,
            userId: "user1",
            imageId: "image1",
            createdAt: "",
            image: FavoriteImage(
                id: "image1",
                url: ""
            )
        ),
        Favorite(
            id: UUID().hashValue,
            userId: "user1",
            imageId: "image2",
            createdAt: "",
            image: FavoriteImage(
                id: "image2",
                url: ""
            )
        ),
        Favorite(
            id: UUID().hashValue,
            userId: "user1",
            imageId: "image3",
            createdAt: "",
            image: FavoriteImage(
                id: "image3",
                url: ""
            )
        ),
    ]
}

extension FavoriteResponse {
    enum ResponseMessage {
        case success

        var message: String {
            switch self {
            case .success: return "Success"
            }
        }
    }

    static let mockSuccessResponse: FavoriteResponse = FavoriteResponse(
        id: UUID().hashValue,
        message: ResponseMessage.success.message
    )
}
#endif
