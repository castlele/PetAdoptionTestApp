import Foundation

struct Photo: Codable, Hashable {

    enum SizeType {
        case small, large
    }

    var small: String?
    var large: String?
}
