import Foundation

enum BreedsViewState {
    case initial
    case loading
    case loadingMore
    case error(String)
    case loaded(_ breeds: [Breed])
}
