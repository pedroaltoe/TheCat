import Foundation

enum BreedsViewState {
    case initial
    case error(String)
    case present(_ displayModel: [Breed])
}
