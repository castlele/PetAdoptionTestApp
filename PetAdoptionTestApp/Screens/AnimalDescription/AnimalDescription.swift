import SwiftUI

struct AnimalDescription: View {

    private enum Constants {
        static let headerImageSize = CGSize(width: 24, height: 24)
        static let headerHeight = 346.0
        static let horizontalInsets = 26.0
        static let headerVerticalInsets = 33.0
        static let sectionSpacing = 37.0
        static let sectionHeaderSpacing = 17.0
        static let quikInfoSpacing = 24.0
        static let quickInfoBlockSpacing = 4.0
        static let quickInfoBlockVerticalInsets = 12.0
        static let quickInfoBlockHorizontalInsets = 22.0
        static let quickInfoBlockCornerRadius = 12.0
    }

    private var safeAreaTop: CGFloat {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets.top ?? 0.0
    }

    @Environment(\.presentationMode) var presentationMode

    let pet: Animal

    private var header: some View {
        ZStack {
            LoadingImage(url: pet.getLargePhotoUrl()) {
                Rectangle()
                    .overlay(ProgressView())
            }
            .frame(width: UIScreen.main.bounds.width, height: Constants.headerHeight)
            .clipped()

            VStack(spacing: .zero) {
                HStack(spacing: .zero) {
                    Button {
                        presentationMode.wrappedValue.dismiss()

                    } label: {
                        Image.backButton
                            .resizable()
                            .frame(size: Constants.headerImageSize)
                    }

                    Spacer()

                    Image.heart
                        .resizable()
                        .frame(size: Constants.headerImageSize)
                }
                .padding(.top, Constants.headerVerticalInsets + safeAreaTop)
                .padding(.horizontal, Constants.horizontalInsets)

                Spacer()
            }
        }
    }

    private var quickInfo: some View {
        HStack(spacing: Constants.quikInfoSpacing) {
            if !pet.getName().isEmpty {
                quickInfoBlock(title: pet.getAge(), subtitle: "Age")
            }

            if !pet.getColor().isEmpty {
                quickInfoBlock(title: pet.getColor(), subtitle: "Color")
            }

            if !pet.getCoat().isEmpty {
                quickInfoBlock(title: pet.getCoat(), subtitle: "Coat")
            }
        }
    }

    var body: some View {
        ScrollView {
            header

            VStack(alignment: .leading) {

                PetInfo(pet: pet)
                    .padding(.bottom, Constants.sectionSpacing)

                if let description = pet.description {
                    VStack(alignment: .leading, spacing: Constants.sectionHeaderSpacing) {
                        header("About me")
                        Text(description)
                    }
                    .padding(.bottom, Constants.sectionSpacing)
                }

                VStack(alignment: .leading, spacing: Constants.sectionHeaderSpacing) {
                    header("Quick Info")

                    quickInfo
                }
                .padding(.bottom, Constants.sectionSpacing)
            }
            .padding(.horizontal, Constants.horizontalInsets)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .background(Color.background.ignoresSafeArea())
    }

    @ViewBuilder
    private func header(_ title: String) -> some View {
        Text(title)
            .font(.title3)
            .bold()
    }

    @ViewBuilder
    private func quickInfoBlock(title: String, subtitle: String) -> some View {
        VStack(spacing: Constants.quickInfoBlockSpacing) {
            Text(title)
                .bold()

            Text(subtitle)
                .font(.subheadline)
        }
        .padding(.horizontal, Constants.quickInfoBlockHorizontalInsets)
        .padding(.vertical, Constants.quickInfoBlockVerticalInsets)
        .background(Color.animalCell)
        .clipShape(RoundedRectangle(cornerRadius: Constants.quickInfoBlockCornerRadius))
    }
}

#if DEBUG
struct AnimalDescription_Previews: PreviewProvider {
    static var previews: some View {
        AnimalDescription(pet: .mockFemaleCatAnimal)
    }
}
#endif
