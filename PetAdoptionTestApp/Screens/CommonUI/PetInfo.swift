import SwiftUI

struct PetInfo: View {

    private enum Constants {
        static let nameBottomPadding = 9.0
        static let ageBottomPadding = 16.0
        static let genderBottomPadding = 40.0
        static let insets = 12.0
        static let mapPinSize = CGSize(width: 11, height: 14)
    }

    let pet: Animal

    var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {
                Text(pet.getName())
                    .font(.title2)
                    .bold()
                    .padding(.bottom, Constants.nameBottomPadding)

                Text(pet.getAge())
                    .padding(.bottom, Constants.ageBottomPadding)

                if !pet.locationDistance.isEmpty {
                    HStack(spacing: Constants.insets) {
                        Image.mapPin
                            .resizable()
                            .frame(size: Constants.mapPinSize)

                        Text(pet.locationDistance)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: .zero) {
                if let gender = pet.getGender() {
                    GenderLabel(gender: gender)
                        .padding(.bottom, Constants.genderBottomPadding)
                }

                Text(pet.getPublishedTime())
            }
        }
    }
}

#if DEBUG
struct PetInfo_Previes: PreviewProvider {
    static var previews: some View {
        PetInfo(pet: .mockFemaleCatAnimal)
    }
}
#endif
