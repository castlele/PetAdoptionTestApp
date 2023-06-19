import Foundation

@MainActor
final class AnimalsListViewModel: ObservableObject {

    private let animalsNetworkRequester: AnimalsNetworkRequester

    private var error: Error? {
        didSet {
            isErrorPresented = error == nil ? false : true
        }
    }

    @Published var isErrorPresented = false
    @Published var animals = [Animal]()

    init(animalsNetworkRequester: AnimalsNetworkRequester) {
        self.animalsNetworkRequester = animalsNetworkRequester
    }

    func getAnimals() {
        Task {
            let result = await animalsNetworkRequester.getAnimals()

            unwrapAnimalsResult(result)
        }
    }

    func getErrorMessage() -> String {
        if let appError = error as? AppError {
            return appError.localizedDescription
        }

        return error?.localizedDescription ?? "Unknown error"
    }

    private func unwrapAnimalsResult(_ result: Result<Animals, Error>) {
        switch result {
        case let .success(success):
            animals = success.animals

        case let .failure(failure):
            error = failure
        }
    }
}
