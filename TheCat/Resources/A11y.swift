enum A11y {
    enum Breeds {
        static var favorite = "Cat breed favorite"
        static var image = "Cat breed image"
        static var list = "Cat breed list"
        static var refreshButton = "Refresh screen button"

        static func name(_ name: String) -> String {
            "Cat breed name \(name)"
        }
    }

    enum Detail {
        static var image = "Cat image"

        static func origin(_ origin: String) -> String {
            "Cat origin \(origin)"
        }

        static func temperament(_ temperament: String) -> String {
            "Cat temperament \(temperament)"
        }

        static func description(_ description: String) -> String {
            "Cat description \(description)"
        }
    }
}
