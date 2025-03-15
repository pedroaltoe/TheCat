import Foundation

enum BreedsViewState {
    case initial
    case loading
    case error(String)
    case present(_ breeds: [Breed])
}
