import Foundation

final class AnimalsNetworkRequester: NetworkRequester {

    static let animalsListStringUrl = "https://api.petfinder.com/v2/animals"
    static let authHeader = "Authorization"

    private let authManager: AuthManager

    private var animalsListUrl: URL {
        guard let url = URL(string: Self.animalsListStringUrl) else {
            fatalError("Can't create animals url")
        }

        return url
    }

    init(authManager: AuthManager, decoder: JSONDecoder = .init()) {
        self.authManager = authManager

        super.init(decoder: decoder)
    }

    func getAnimals() async -> Result<Animals, Error> {
        let authResult = await provideAuntification()

        guard authResult == nil else {
            return .failure(authResult!)
        }

        return await request(url: animalsListUrl)
    }

    override func createRequest(forUrl url: URL, type: RequestType) async -> URLRequest {
        var request = URLRequest(url: url)
        let tokenType = await authManager.getTokenType()
        let accessToken = await authManager.getAccessToken()

        guard let tokenType, let accessToken else {
            return await super.createRequest(forUrl: url, type: type)
        }

        request.setValue("\(tokenType) \(accessToken)", forHTTPHeaderField: Self.authHeader)

        return request
    }

    private func provideAuntification() async -> Error? {
        let authResult = await authManager.authIfNeeded()

        if case let .failure(error) = authResult {
            return error
        }

        return nil
    }
}
