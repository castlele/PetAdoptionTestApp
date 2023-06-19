import SwiftUI

struct GenderLabel: View {

    private enum Constants {
        static let horizontalInsets = 12.0
        static let verticalInsets = 5.0
        static let labelCornerRadius = 31.0
    }

    let gender: Gender

    private var genderColor: Color {
        var color: Color

        switch gender {
        case .male:
            color = .maleGender
        case .female:
            color = .femaleGender
        }

        return color
    }

    private var backgroundColor: some View {
        genderColor.opacity(0.1)
    }

    var body: some View {
        Text(gender.rawValue.capitalized)
            .foregroundColor(genderColor)
            .padding(.horizontal, Constants.horizontalInsets)
            .padding(.vertical, Constants.verticalInsets)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.labelCornerRadius))
    }
}

#if DEBUG
struct GenderLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GenderLabel(gender: .male)

            GenderLabel(gender: .female)
        }
    }
}
#endif
