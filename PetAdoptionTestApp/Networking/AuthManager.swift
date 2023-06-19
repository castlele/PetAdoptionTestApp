import Foundation

actor AuthManager {

    private enum Constants {
        static let expirationDateKey = "expiration_date"
    }

    static let stringUrl = "https://api.petfinder.com/v2/oauth2/token"

    private let networkRequester: NetworkRequester
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private var clientId: String {
        ProcessInfo.processInfo.environment["CLIENT_ID"] ?? ""
    }

    private var clientSecret: String {
        ProcessInfo.processInfo.environment["CLIENT_SECRET"] ?? ""
    }

    private var authUrl: URL {
        guard let url = URL(string: Self.stringUrl) else {
            fatalError("Can't create valid auth url")
        }

        return url
    }

    private var expirationDate: Date? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Constants.expirationDateKey) else {
                return nil
            }

            return try? decoder.decode(Date.self, from: data)
        }
        set {
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: Constants.expirationDateKey)
        }
    }

    private var token: Token? {
        didSet {
            saveExpirationDate()
        }
    }

    private var isTokenValid: Bool {
        guard let expirationDate else {
            return false
        }

        return Date() < expirationDate
    }

    init(networkRequester: NetworkRequester, encoder: JSONEncoder = .init(), decoder: JSONDecoder = .init()) {
        self.networkRequester = networkRequester
        self.encoder = encoder
        self.decoder = decoder
    }

    func authIfNeeded() async -> Result<Token, Error> {
        if let token, isTokenValid {
            return .success(token)
        }

        return await auth()
    }

    func auth() async -> Result<Token, Error> {
        let result: Result<Token, Error> = await networkRequester.request(url: authUrl, type: .post, request: { url, type in
            var request = URLRequest(url: url)

            request.httpMethod = type.rawValue.uppercased()
            request.httpBody = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)".data(using: .utf8)

            return request
        })

        if case let .success(token) = result {
            self.token = token
        } else {
            self.token = nil
        }

        return result
    }

    func getTokenType() -> String? {
        token?.tokenType
    }

    func getAccessToken() -> String? {
        token?.accessToken
    }

    private func saveExpirationDate() {
        guard let token else {
            return
        }

        let date = Date().addingTimeInterval(TimeInterval(token.expireTime))
        expirationDate = date
    }
}
