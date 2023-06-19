import SwiftUI

struct AnimalsList: View {

    private enum Constants {
        static let bulbImageSize = CGSize(width: 24, height: 24)
        static let horizontalInsets = 19.0
        static let mainTitleBottomPadding = 35.0
        static let listHeaderBottomPadding = 20.0
        static let animalCellBottomPadding = 12.0
    }

    @EnvironmentObject var animalsListViewModel: AnimalsListViewModel

    var title: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hey Spikey,")
                    .font(.largeTitle)
                    .bold()

                Text("Adopt a new friend near you!")
                    .font(.caption)
            }

            Spacer()

            Image.bulbIcon
                .resizable()
                .frame(size: Constants.bulbImageSize)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: .zero) {
                    title
                        .padding(.bottom, Constants.mainTitleBottomPadding)

                    HStack(spacing: Constants.listHeaderBottomPadding) {
                        Text("Nearby results")
                            .font(.footnote)
                            .bold()

                        if animalsListViewModel.animals.isEmpty {
                            ProgressView()
                        }
                    }
                    .padding(.bottom, Constants.listHeaderBottomPadding)

                    ForEach(animalsListViewModel.animals, id: \.self) { pet in
                        NavigationLink {
                            AnimalDescription(pet: pet)
                        } label: {
                            AnimalCell(pet)
                                .padding(.bottom, Constants.animalCellBottomPadding)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Spacer()
                }
            }
            .padding(.horizontal, Constants.horizontalInsets)
            .navigationBarHidden(true)
            .background(Color.background.ignoresSafeArea())
            .alert(isPresented: $animalsListViewModel.isErrorPresented) {
                Alert(title: Text("Error"), message: Text(animalsListViewModel.getErrorMessage()))
            }
            .onAppear {
                animalsListViewModel.getAnimals()
            }
        }
    }
}

#if DEBUG
struct AnimalsList_Previews: PreviewProvider {
    static var previews: some View {
        AnimalsList()
            .environmentObject(AnimalsListViewModel(animalsNetworkRequester: .init(authManager: .init(networkRequester: .init()))))
    }
}
#endif
