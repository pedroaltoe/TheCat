import Foundation

enum Space {
    static let small: CGFloat = 6
    static let medium: CGFloat = 12
    static let large: CGFloat = 18
    static let extraLarge: CGFloat = 24
    static let extraExtraLarge: CGFloat = 30
}

enum Constants {
    enum Image {
        enum Size {
            static let profile: CGFloat = 200
            static let breed: CGFloat = 100
        }

        static let catsList = "square.grid.3x3.fill"
        static let fail = "photo.badge.exclamationmark"
        static let favorite = "star.fill"
        static let favourites = "square.grid.3x3.fill"
        static let placeHolder = "photo"
        static let notFavorite = "star"
    }

    enum Item {
        static let size: CGFloat = 110
    }
} 
