import SwiftUI

struct ContentView: View {

    var viewModel: ContentViewModel

    var body: some View {
        TabView {
            BreedsView(viewModel: BreedsViewModel(contentViewModel: viewModel))
                .tabItem {
                    Label(Localized.Breeds.catsListButton, systemImage: Constants.Image.catsList)
                }

            FavoritesView(viewModel: FavoritesViewModel(contentViewModel: viewModel))
                .tabItem {
                    Label(Localized.Breeds.favouritesButton, systemImage: Constants.Image.favorites)    
                }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#if targetEnvironment(simulator)
#Preview {
    let contentViewModel = ContentViewModel(repository: RepositoryBuilder.makeRepository(api: APIClientMock()))
    ContentView(viewModel: contentViewModel)
}
#endif
