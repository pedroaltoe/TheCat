import SwiftUI

@main
struct TheCatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                coordinator: Coordinator(),
                contentViewModel: ContentViewModel(
                    repository: RepositoryBuilder.makeRepository(api: APIClient())
                )
            )
        }
    }
}
