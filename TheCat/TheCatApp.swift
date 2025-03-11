import SwiftUI

@main
struct TheCatApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                BreedsView(viewModel: BreedsViewModel())
                    .navigationTitle(Constants.Text.title)
            }
        }
    }
}
