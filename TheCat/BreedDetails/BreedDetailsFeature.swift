import ComposableArchitecture
import SwiftUI
import Observation

@Reducer
struct BreedDetailsFeature {

    let contentViewModel: ContentViewModel

    // MARK: Action

    enum Action: Equatable {
        case toggleFavorite(String?)
        case isBreedFavorite(String?)
        case isBreedFavoriteResponse(Bool)
    }

    // MARK: State

    @ObservableState
    struct State: Equatable {
        let breed: Breed
        var isFavorite = false
    }

    // MARK: Reducer Body

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .toggleFavorite(imageId):
                state.isFavorite.toggle()
                return .run { send in
                    try? await self.contentViewModel.toggleFavorite(imageId: imageId)
                }
            case let .isBreedFavorite(imageId):
                return .run { send in
                    let isFavorite = await self.contentViewModel.isFavorite(imageId: imageId)
                    await send(.isBreedFavoriteResponse(isFavorite))
                }
            case let .isBreedFavoriteResponse(isFavorite):
                state.isFavorite = isFavorite
                return .none
            }
        }
    }
}
