import SwiftUI

struct FavoritesView: View {

    @Bindable var viewModel: FavoritesViewModel

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
        case .empty:
            ContentUnavailableView(
                A11y.Favorites.emptyTitle,
                systemImage: Constants.Image.emptyFavoritesImage
            )
        case let .present(breeds):
            contentView(breeds)
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
            .accessibilityLabel(A11y.Favorites.list)
            .accessibilityIdentifier("Cat favorites list")
        }
    }

    @ViewBuilder func item(_ breed: BreedDisplayModel) -> some View {
        VStack(spacing: Space.small) {
            ZStack(alignment: .topTrailing) {
                breedImage(breed)
                    .accessibilityLabel(A11y.Favorites.image)
                    .accessibilityIdentifier("Cat favorite image")

                favouriteButton(breed)
            }

            Text(breed.lifeSpan)
                .font(.system(size: 12))
                .accessibilityLabel(A11y.Favorites.lifeSpan(breed.lifeSpan))
                .accessibilityIdentifier("Cat favorite lifeSpan")
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

    @ViewBuilder func favouriteButton(_ breed: BreedDisplayModel) -> some View {
        Button {
            Task {
                await viewModel.toggleFavorite(breed)
            }
        } label: {
            Image(systemName: Constants.Image.favorite)
                .renderingMode(.original)
                .font(.title).fontWeight(.bold)
                .accessibilityLabel(A11y.Breeds.favorite)
                .accessibilityIdentifier("Cat breed favorite")
        }
    }
}

#if targetEnvironment(simulator)
#Preview {
    let contentViewModel = ContentViewModel(repository: RepositoryBuilder.makeRepository(api: APIClientMock()))
    BreedsView(viewModel: BreedsViewModel(contentViewModel: contentViewModel))
}
#endif
