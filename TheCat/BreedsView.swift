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
                    await viewModel.fetchBreeds()
                }
                .refreshable {
                    await viewModel.fetchBreeds()
                }
        case .loading:
            progressView
        case let .loaded(breeds):
            loadedView(breeds)
                .refreshable {
                    await viewModel.fetchBreeds()
                }
        case let .error(error):
            VStack(spacing: Space.medium) {
                Text(error.capitalizingFirstLetter())
                    .font(.title3)
                
                Button {
                    viewModel.refresh()
                } label: {
                    Text(Constants.Text.refresh)
                }
                .buttonStyle(.borderedProminent)
                .font(.body)
            }
            
        case .loadingMore:
            progressView
        }
    }
    
    @ViewBuilder var progressView: some View {
        ProgressView()
            .progressViewStyle(.linear)
            .padding()
    }
    
    @ViewBuilder func loadedView(_ breeds: [Breed]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Space.large) {
                ForEach(breeds) { breed in
                    VStack(spacing: Space.small) {
                        ZStack(alignment: .topTrailing) {
                            breedImage(breed)
                            
                            if breed.isFavorite == true {
                                Image(systemName: Constants.Image.favorite)
                                    .renderingMode(.original)
                            }
                        }
                        
                        Text(breed.name)
                            .font(.system(size: 12))
                    }
                }
            }
            .padding()
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
                    .scaledToFit()
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

//#Preview {
//    BreedsView()
//}
