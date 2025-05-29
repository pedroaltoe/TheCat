import Foundation

struct Favorite: Codable {
    let id: Int
    let userId: String
    let imageId: String
    let subId: String
    let createdAt: String
    let image: FavoriteImage
}

struct FavoriteImage: Codable {
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
            subId: "1234",
            createdAt: "",
            image: FavoriteImage(
                url: ""
            )
        ),
        Favorite(
            id: UUID().hashValue,
            userId: "user1",
            imageId: "image2",
            subId: "1234",
            createdAt: "",
            image: FavoriteImage(
                url: ""
            )
        ),
        Favorite(
            id: UUID().hashValue,
            userId: "user1",
            imageId: "image3",
            subId: "1234",
            createdAt: "",
            image: FavoriteImage(
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
