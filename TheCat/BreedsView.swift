import SwiftUI

struct BreedsView: View {

    @ObservedObject var viewModel: BreedsViewModel

    let columns = [
        GridItem(.adaptive(minimum: Constants.Item.size))
    ]

    var body: some View {
        switch viewModel.viewState {
        case .initial:
            progressView
                .task {
                    viewModel.fetchBreeds()
                }
                .refreshable {
                    viewModel.fetchBreeds()
                }
        case .loading:
            progressView
        case let .loaded(breeds):
            loadedView(breeds)
                .refreshable {
                    viewModel.fetchBreeds()
                }
        case let .error(error):
            VStack(spacing: Space.medium) {
                Text(error.capitalizingFirstLetter())
                    .font(.title3)

                Button {
                    viewModel.fetchBreeds()
                } label: {
                    Text(Constants.Text.refresh)
                }
                .buttonStyle(.borderedProminent)
                .font(.body)
                .accessibilityLabel(A11y.Breeds.refreshButton)
                .accessibilityIdentifier("Refresh button")
            }
        }
    }

    @ViewBuilder var progressView: some View {
        ProgressView()
            .padding()
    }

    @ViewBuilder func loadedView(_ breeds: [Breed]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Space.large) {
                ForEach(breeds) { breed in
                    VStack(spacing: Space.small) {
                        ZStack(alignment: .topTrailing) {
                            breedImage(breed)
                                .accessibilityLabel(A11y.Breeds.image)
                                .accessibilityIdentifier("Cat breed image")

                            if breed.isFavorite == true {
                                Image(systemName: Constants.Image.favorite)
                                    .renderingMode(.original)
                                    .accessibilityLabel(A11y.Breeds.favorite)
                                    .accessibilityIdentifier("Cat breed favorite")
                            }
                        }

                        Text(breed.name)
                            .font(.system(size: 12))
                            .accessibilityLabel(A11y.Breeds.name)
                            .accessibilityIdentifier("Cat breed name")
                    }
                }
            }
            .padding()
            .accessibilityLabel(A11y.Breeds.list)
            .accessibilityIdentifier("Cat breed list")
        }
    }

    @ViewBuilder func breedImage(_ breed: Breed) -> some View {
        CacheAsyncImage(url: URL(string: breed.image?.url ?? "")) { phase in
            switch phase {
            case .empty:
                Image(systemName: Constants.Image.placeHolder)
                    .font(.largeTitle)
            case .failure(_):
                Image(systemName: Constants.Image.fail)
                    .font(.largeTitle)
            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: Constants.Image.size,
                        height: Constants.Image.size
                    )
                    .clipShape(
                        .rect(cornerRadius: 5)
                    )
            @unknown default:
                Image(systemName: Constants.Image.placeHolder)
                    .font(.largeTitle)
            }
        }
        .frame(
            width: Constants.Image.size,
            height: Constants.Image.size
        )
    }
}

#Preview {
    BreedsView(viewModel: BreedsViewModel())
}
