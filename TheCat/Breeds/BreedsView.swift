import SwiftUI

struct BreedsView: View {

    @Bindable var viewModel: BreedsViewModel

    let columns = [
        GridItem(.adaptive(minimum: Constants.Item.size))
    ]

    // MARK: Body

    var body: some View {
        switch viewModel.viewState {
        case .initial:
            progressView
                .onAppear {
                    viewModel.onAppear()
                }
        case let .present(breeds):
            contentView(breeds)
                .refreshable {
                    viewModel.onRefresh()
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
                    viewModel.onRefresh()
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

    @ViewBuilder func contentView(_ breeds: [BreedDisplayModel]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Space.large) {
                ForEach(breeds) { breed in
                    item(breed)
                        .tint(.primary)
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

    @ViewBuilder func item(_ breed: BreedDisplayModel) -> some View {
        VStack(spacing: Space.small) {
            ZStack(alignment: .topTrailing) {
                breedImage(breed)
                    .accessibilityLabel(A11y.Breeds.image)
                    .accessibilityIdentifier("Cat breed image")

                breed.isFavorite == true
                ? favoriteButton(breed, Constants.Image.favorite)
                : favoriteButton(breed, Constants.Image.notFavorite)
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

    @ViewBuilder func breedImage(_ breed: BreedDisplayModel) -> some View {
        CacheAsyncImage(url: URL(string: breed.imageUrl ?? "")) { phase in
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
                        width: Constants.Image.Size.breed,
                        height: Constants.Image.Size.breed
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
            width: Constants.Image.Size.breed,
            height: Constants.Image.Size.breed
        )
    }

    @ViewBuilder func favoriteButton(_ breed: BreedDisplayModel, _ image: String) -> some View {
        Button {
            Task {
                await viewModel.toggleFavorite(breed.id)
            }
        } label: {
            Image(systemName: image)
                .renderingMode(.original)
                .font(.title).fontWeight(.bold)
                .accessibilityLabel(A11y.Breeds.favorite)
                .accessibilityIdentifier("Cat breed \(image == Constants.Image.notFavorite ? "not " : "")favorite")
        }
    }
}

#if targetEnvironment(simulator)
#Preview {
    let contentViewModel = ContentViewModel(repository: RepositoryBuilder.makeRepository(api: APIClientMock()))
    BreedsView(viewModel: BreedsViewModel(contentViewModel: contentViewModel))
}
#endif
