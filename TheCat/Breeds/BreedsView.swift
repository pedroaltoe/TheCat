import SwiftUI

struct BreedsView: View {

    @ObservedObject var viewModel: BreedsViewModel

    @State private var isShowingDetailView = false

    let columns = [
        GridItem(.adaptive(minimum: Constants.Item.size))
    ]

    // MARK: Body

    var body: some View {
        switch viewModel.viewState {
        case .initial:
            progressView
                .task {
                    viewModel.fetchFavourites()
                }
        case let .present(breeds):
            contentView(breeds)
                .refreshable {
                    viewModel.refreshBreeds()
                }
                .overlay {
                    if viewModel.isLoadingMore {
                        progressView
                    }
                }
        case let .error(error):
            VStack(spacing: Space.medium) {
                Text(error.capitalizingFirstLetter())
                    .font(.title3)

                Button {
                    viewModel.refreshBreeds()
                } label: {
                    Text(Localized.Breeds.refresh)
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
            .controlSize(.large)
            .padding()
    }

    // MARK: Content

    @ViewBuilder func contentView(_ breeds: [Breed]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Space.large) {
                ForEach(breeds) { breed in
                    NavigationLink {
                        BreedDetailsView(viewModel: BreedDetailsViewModel(breed: breed))
                    } label: {
                        item(breed)
                            .tint(.primary)
                    }
                }
            }
            .padding()
            .accessibilityLabel(A11y.Breeds.list)
            .accessibilityIdentifier("Cat breed list")
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always)
        )
    }

    @ViewBuilder func item(_ breed: Breed) -> some View {
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
                .accessibilityLabel(A11y.Breeds.name(breed.name))
                .accessibilityIdentifier("Cat breed name")
        }
        .onAppear {
            viewModel.fetchMoreBreeds(from: breed.id)
        }
    }

    // MARK: Image

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
