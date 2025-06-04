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

    // MARK: Progress view

    @ViewBuilder var progressView: some View {
        ProgressView()
            .controlSize(.large)
            .padding()
    }

    // MARK: Content

    @ViewBuilder func contentView(_ breeds: [Breed]) -> some View {
        ScrollView {
            if breeds.isEmpty {
                ContentUnavailableView(
                    Localized.Breeds.emptyTitle,
                    systemImage: Constants.Image.placeHolder
                )
                .padding()
                .accessibilityLabel(A11y.Breeds.emptyList)
                .accessibilityIdentifier("Cat breed empty list")
            } else {
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

                viewModel.isBreedFavorite(imageId: breed.referenceImageId)
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

    // MARK: Favorite button

    @ViewBuilder func favoriteButton(_ breed: Breed, _ image: String) -> some View {
        Button {
            Task {
                await viewModel.toggleFavorite(imageId: breed.referenceImageId)
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

// MARK: Preview

#if targetEnvironment(simulator)
#Preview {
    let contentViewModel = ContentViewModel(repository: RepositoryBuilder.makeRepository(api: APIClientMock()))
    BreedsView(viewModel: BreedsViewModel(contentViewModel: contentViewModel))
}
#endif
