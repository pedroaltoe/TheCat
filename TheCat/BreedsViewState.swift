import Foundation

enum BreedsViewState {
    case initial
    case loading
    case error(String)
    case loaded(_ breeds: [Breed])
}
