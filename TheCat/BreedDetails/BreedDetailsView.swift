import SwiftUI

struct BreedDetailsView: View {

    @Bindable var viewModel: BreedDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: Space.extraExtraLarge) {
                HStack {
                    Spacer()

                    viewModel.isBreedFavorite(imageId: viewModel.breed.referenceImageId)
                    ? favoriteButton(viewModel.breed, Constants.Image.favorite)
                    : favoriteButton(viewModel.breed, Constants.Image.notFavorite)
                }

                image
                    .accessibilityLabel(A11y.Details.image)
                    .accessibilityIdentifier("Image")

                VStack(alignment: .leading, spacing: Space.medium) {
                    Text("\(Localized.Details.origin): \(viewModel.breed.origin)")
                        .font(.subheadline)
                        .accessibilityLabel(A11y.Details.origin(viewModel.breed.origin))
                        .accessibilityIdentifier("Origin")

                    Text("\(Localized.Details.temperament): \(viewModel.breed.temperament)")
                        .font(.subheadline)
                        .accessibilityLabel(A11y.Details.temperament(viewModel.breed.temperament))
                        .accessibilityIdentifier("Temperament")

                    Text("\(Localized.Details.description): \(viewModel.breed.description)")
                        .font(.body)
                        .lineLimit(nil)
                        .accessibilityLabel(A11y.Details.description(viewModel.breed.description))
                        .accessibilityIdentifier("Description")
                }
            }
        }
        .navigationTitle(viewModel.breed.name)
        .padding(.horizontal, Space.large)
    }

    // MARK: Favorite button

    @ViewBuilder func favoriteButton(_ breed: Breed, _ image: String) -> some View {
        Button {
            Task {
                await viewModel.toggleFavorite(imageId: breed.referenceImageId)
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

    @ViewBuilder var image: some View {
        AsyncImage(url: URL(string: viewModel.breed.image?.url ?? "")) { phase in
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

// MARK: Preview

#if targetEnvironment(simulator)
#Preview {
    let contentViewModel = ContentViewModel(repository: RepositoryBuilder.makeRepository(api: APIClientMock()))
    BreedDetailsView(
        viewModel: BreedDetailsViewModel(
            breed: Breed.mockBreeds[0],
            contentViewModel: contentViewModel
        )
    )
}
#endif
