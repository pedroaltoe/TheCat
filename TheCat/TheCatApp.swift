import SwiftUI

@main
struct TheCatApp: App {

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TabView {
                    BreedsView(viewModel: BreedsViewModel())
                        .tabItem {
                            Label(Localized.catsListButton, systemImage: Constants.Image.catsList)
                        }
                }
                .navigationTitle(Localized.title)
            }
        }
    }
}
