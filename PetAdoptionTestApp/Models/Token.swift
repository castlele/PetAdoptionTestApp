import Foundation

struct Token: Codable {
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expireTime = "expires_in"
        case accessToken = "access_token"
    }

    let tokenType: String
    let expireTime: Int
    let accessToken: String
}
