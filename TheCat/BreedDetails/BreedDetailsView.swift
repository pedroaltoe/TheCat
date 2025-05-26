import SwiftUI

struct BreedDetailsView: View {

    @Bindable var viewModel: BreedDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: Space.extraExtraLarge) {
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

        Spacer()

        Button {
            print("Add to favourites")
        } label: {
            Text(Localized.Details.addToFavouritesButton)
        }
        .buttonStyle(.borderedProminent)
        .font(.body)
        .accessibilityLabel(A11y.Details.addToFavouritesButton)
        .accessibilityIdentifier("Add to favourites button")
    }

    @ViewBuilder var image: some View {
        AsyncImage(url: URL(string: viewModel.breed.image?.url ?? "")) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: Constants.Image.profileSize,
                        height: Constants.Image.profileSize
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

#if targetEnvironment(simulator)
#Preview {
    BreedDetailsView(viewModel: BreedDetailsViewModel(breed: Breed.mockBreeds[0]))
}
#endif
