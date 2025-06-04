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
                    viewModel.checkFavorites()
                }
        case .empty:
            ContentUnavailableView(
                A11y.Favorites.emptyTitle,
                systemImage: Constants.Image.emptyFavoritesImage
            )
        case let .present(breeds):
            contentView(breeds)
                .onAppear {
                    viewModel.checkFavorites()
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
                    item(breed)
                        .tint(.primary)
                }
            }
            .padding()
            .accessibilityLabel(A11y.Favorites.list)
            .accessibilityIdentifier("Cat favorites list")
        }
    }

    @ViewBuilder func item(_ breed: Breed) -> some View {
        VStack(spacing: Space.small) {
            ZStack(alignment: .topTrailing) {
                breedImage(breed)
                    .accessibilityLabel(A11y.Favorites.image)
                    .accessibilityIdentifier("Cat favorite image")

                favouriteButton(imageId: breed.referenceImageId)
            }

            VStack {
                Text(breed.name)
                    .font(.system(size: 12))
                    .accessibilityLabel(A11y.Breeds.name(breed.name))
                    .accessibilityIdentifier("Cat breed name")

                Text(A11y.Favorites.lifeSpan(breed.lifeSpan))
                    .font(.system(size: 12))
                    .accessibilityLabel(A11y.Favorites.lifeSpan(breed.lifeSpan))
                    .accessibilityIdentifier("Cat favorite lifeSpan")
            }
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

    @ViewBuilder func favouriteButton(imageId: String?) -> some View {
        Button {
            Task {
                await viewModel.toggleFavorite(imageId: imageId)
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
