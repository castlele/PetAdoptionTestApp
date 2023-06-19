import SwiftUI

@main
struct PetAdoptionTestAppApp: App {

    @ObservedObject var animalsListViewModel: AnimalsListViewModel

    init() {
        let authRequster = NetworkRequester()
        let authManager = AuthManager(networkRequester: authRequster)
        let animalsNetworkRequester = AnimalsNetworkRequester(authManager: authManager)

        self.animalsListViewModel = AnimalsListViewModel(animalsNetworkRequester: animalsNetworkRequester)
    }

    var body: some Scene {
        WindowGroup {
            AnimalsList()
                .environmentObject(animalsListViewModel)
        }
    }
}
