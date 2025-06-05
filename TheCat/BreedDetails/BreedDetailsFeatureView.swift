import ComposableArchitecture
import SwiftUI

struct BreedDetailsFeatureView: View {

    let store: StoreOf<BreedDetailsFeature>

    var body: some View {
        contentView(store.breed)
    }

    // MARK: Progress view

    @ViewBuilder var progressView: some View {
        ProgressView()
            .controlSize(.large)
            .padding()
    }

    // MARK: Content

    @ViewBuilder func contentView(_ breed: Breed) -> some View {
        ScrollView {
            VStack(spacing: Space.extraExtraLarge) {
                HStack {
                    Spacer()

                    store.isFavorite
                    ? favoriteButton(breed, Constants.Image.favorite)
                    : favoriteButton(breed, Constants.Image.notFavorite)
                }

                breedImage(breed)
                    .accessibilityLabel(A11y.Details.image)
                    .accessibilityIdentifier("Image")

                VStack(alignment: .leading, spacing: Space.medium) {
                    Text("\(Localized.Details.origin): \(breed.origin)")
                        .font(.subheadline)
                        .accessibilityLabel(A11y.Details.origin(breed.origin))
                        .accessibilityIdentifier("Origin")

                    Text("\(Localized.Details.temperament): \(breed.temperament)")
                        .font(.subheadline)
                        .accessibilityLabel(A11y.Details.temperament(breed.temperament))
                        .accessibilityIdentifier("Temperament")

                    Text("\(Localized.Details.description): \(breed.description)")
                        .font(.body)
                        .lineLimit(nil)
                        .accessibilityLabel(A11y.Details.description(breed.description))
                        .accessibilityIdentifier("Description")
                }
            }
        }
        .padding(.horizontal, Space.large)
    }

    // MARK: Favorite button

    @ViewBuilder func favoriteButton(_ breed: Breed, _ image: String) -> some View {
        Button {
            Task {
                store.send(.toggleFavorite(breed.referenceImageId))
            }
        } label: {
            Image(systemName: image)
                .renderingMode(.original)
                .font(.largeTitle).fontWeight(.bold)
                .accessibilityLabel(A11y.Breeds.favorite)
                .accessibilityIdentifier("Cat breed \(image == Constants.Image.notFavorite ? "not " : "")favorite")
        }
    }

    // MARK: Image

    @ViewBuilder func breedImage(_ breed: Breed) -> some View {
        AsyncImage(url: URL(string: breed.image?.url ?? "")) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: Constants.Image.Size.profile,
                        height: Constants.Image.Size.profile
                    )
                    .clipShape(
                        .rect(cornerRadius: 5)
                    )
            default:
                Image(systemName: Constants.Image.placeHolder)
                    .font(.largeTitle)
            }
        }
    }
}
