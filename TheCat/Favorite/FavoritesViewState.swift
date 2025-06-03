import Foundation

enum FavoritesViewState {
    case initial
    case empty
    case present(_ displayModel: [BreedDisplayModel])
}
