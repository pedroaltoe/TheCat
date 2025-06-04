import Foundation

enum Localized {
    enum Breeds {
        static let refresh = String(localized: "Refresh")
        static let title = String(localized: "Breeds list")
        static let catsListButton = String(localized: "Cats List")
        static let favouritesButton = String(localized: "Favourites")
        static let emptyTitle = String(localized: "Breeds list is empty")
    }

    enum Favorites {
        static let emptyTitle = String(localized:"Favorites list is empty")
        static let title = String(localized: "Favorite list")

        static func lifeSpan(_ lifeSpan: String) -> String {
            "\(String(localized:"Lifespan:")) \(lifeSpan)"
        }

    }

    enum Details {
        static let origin = String(localized: "Origin")
        static let temperament = String(localized: "Temperament")
        static let description = String(localized: "Description")
        static let addToFavouritesButton = String(localized: "Add to favourites")
    }
}
