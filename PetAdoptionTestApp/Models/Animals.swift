import Foundation

struct Animals: Codable {
    let animals: [Animal]
}

#if DEBUG

// MARK: - Mock Data

extension Animals {
    static let mockAnimals: [Animal] = [.mockMaleCatAnimal, .mockFemaleCatAnimal]
}
#endif
