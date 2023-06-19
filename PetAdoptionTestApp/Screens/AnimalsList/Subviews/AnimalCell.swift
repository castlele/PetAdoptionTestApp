import SwiftUI

struct AnimalCell: View {

    private enum Constants {
        static let imageSize = CGSize(width: 93, height: 96)
        static let imageCornerRadius = 12.0
        static let cellCornerRadius = 16.0
        static let insets = 12.0
        static let petInfoSpacing = 18.0
    }

    private let pet: Animal

    var body: some View {
        ZStack {
            Color.animalCell

            HStack(spacing: .zero) {
                LoadingImage(url: pet.getSmallPhotoUrl(), placeholder: {
                    ProgressView()
                })
                .frame(size: Constants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))

                PetInfo(pet: pet)
                    .padding(.leading, Constants.petInfoSpacing)

                Spacer()
            }
            .padding(Constants.insets)
        }
        .frame(height: 120)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cellCornerRadius))
    }

    init(_ pet: Animal) {
        self.pet = pet
    }
}

#if DEBUG
struct AnimalCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnimalCell(.mockFemaleCatAnimal)

            AnimalCell(.mockMaleCatAnimal)
        }
    }
}
#endif
