enum A11y {
    enum Breeds {
        static let favorite = "Cat breed favorite"
        static let image = "Cat breed image"
        static let list = "Cat breed list"
        static let refreshButton = "Refresh screen button"

        static func name(_ name: String) -> String {
            "Cat breed name \(name)"
        }
    }

    enum Favorites {
        static let emptyImage = "star.slash"
        static let emptyTitle = "Favorites list is empty"
        static let image = "Cat favorite image"
        static let list = "Cat favorites list"

        static func lifeSpan(_ lifeSpan: String) -> String {
            "Cat breed life span \(lifeSpan)"
        }
    }

    enum Details {
        static let image = "Cat image"

        static func origin(_ origin: String) -> String {
            "Cat origin \(origin)"
        }

        static func temperament(_ temperament: String) -> String {
            "Cat temperament \(temperament)"
        }

        static func description(_ description: String) -> String {
            "Cat description \(description)"
        }

        static let addToFavouritesButton = "Add to favourites button"
    }
}
