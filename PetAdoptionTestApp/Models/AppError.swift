import Foundation

enum AppError: String, Error {
    case auth = "Auntification error. Check your credentials."
    case resourcesNotFound = "Requested resources were not found"
    case unknown = "Unknown error occured"

    var localizedDescription: String {
        self.rawValue
    }

    init(code: Int) {
        switch code {
        case 400, 401, 403:
            self = .auth

        case 404:
            self = .resourcesNotFound

        default:
            self = .unknown
        }
    }
}
