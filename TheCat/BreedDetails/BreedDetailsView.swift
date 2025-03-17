import SwiftUI

struct BreedDetailsView: View {

    @ObservedObject var viewModel: BreedDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: Space.extraExtraLarge) {
                image
                    .accessibilityLabel(A11y.Detail.image)
                    .accessibilityIdentifier("Image")

                VStack(alignment: .leading, spacing: Space.medium) {
                    Text("\(Localized.origin): \(viewModel.breed.origin)")
                        .font(.subheadline)
                        .accessibilityLabel(A11y.Detail.origin(viewModel.breed.origin))
                        .accessibilityIdentifier("Origin")

                    Text("\(Localized.temperament): \(viewModel.breed.temperament)")
                        .font(.subheadline)
                        .accessibilityLabel(A11y.Detail.temperament(viewModel.breed.temperament))
                        .accessibilityIdentifier("Temperament")

                    Text("\(Localized.description): \(viewModel.breed.description)")
                        .font(.body)
                        .lineLimit(nil)
                        .accessibilityLabel(A11y.Detail.description(viewModel.breed.description))
                        .accessibilityIdentifier("Description")
                }
            }
        }
        .navigationTitle(viewModel.breed.name)
        .padding(.horizontal, Space.large)
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

#Preview {
    BreedDetailsView(viewModel: BreedDetailsViewModel(breed: Breed.mockBreeds[0]))
}
