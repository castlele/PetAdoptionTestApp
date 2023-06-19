import Foundation

struct Animal: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case gender
        case publishedTime = "published_at"
        case distance
        case description
        case color
        case coat
        case photos
    }

    private let dateFormatter = DateFormatter()
//        let dateFormatter = DateFormatter()
//
//
//        return dateFormatter
//    }()

    let name: String?
    let age: String?
    let gender: String?
    let publishedTime: String?
    let distance: Int?
    let description: String?
    let color: String?
    let coat: String?
    let photos: [Photo]?

    var locationDistance: String {
        guard let distance else {
            return ""
        }

        return "\(distance)m away"
    }

    func getName() -> String {
        name ?? ""
    }

    func getGender() -> Gender? {
        guard let gender, let gender = Gender(rawValue: gender.lowercased()) else {
            return nil
        }

        return gender
    }

    func getAge() -> String {
        age ?? ""
    }

    func getColor() -> String {
        color ?? ""
    }

    func getCoat() -> String {
        coat ?? ""
    }

    func getPublishedTime() -> String {
        guard let publishedTime else {
            return ""
        }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let date = dateFormatter.date(from: publishedTime) else {
            return ""
        }

        let calendar = Calendar.current

        guard let minutes = calendar.dateComponents([.minute], from: date, to: Date()).minute else {
            return ""
        }

        return "\(minutes) min ago"
    }

    func getSmallPhotoUrl() -> URL? {
        getPhotoBySize(.small)
    }

    func getLargePhotoUrl() -> URL? {
        getPhotoBySize(.large)
    }

    private func getPhotoBySize(_ size: Photo.SizeType) -> URL? {
        guard let photo = photos?.first else {
            return nil
        }

        let stringUrl: String?

        switch size {
        case .small:
            stringUrl = photo.small

        case .large:
            stringUrl = photo.large
        }

        guard let stringUrl else {
            return nil
        }

        return URL(string: stringUrl)
    }
}

#if DEBUG

// MARK: - Mock data

extension Animal {
    static let mockMaleCatAnimal = Animal(name: "Boris",
                                          age: "2 yrs",
                                          gender: "Male",
                                          publishedTime: "12 min ago",
                                          distance: 181,
                                          description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,",
                                          color: "Brown",
                                          coat: "long",
                                          photos: nil)

    static let mockFemaleCatAnimal = Animal(name: "Lea",
                                            age: "2 yrs",
                                            gender: "Female",
                                            publishedTime: "12 min ago",
                                            distance: 181,
                                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,",
                                            color: "Brown",
                                            coat: "long",
                                            photos: nil)
}
#endif
