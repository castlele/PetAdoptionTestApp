import SwiftUI

struct LoadingImage<Placeholder: View>: View {

    @State private var image: UIImage?
    private let networkRequester = NetworkRequester()

    let url: URL?
    @ViewBuilder let placeholder: () -> Placeholder

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder()
            }
        }
        .onAppear {
            guard let url else {
                return
            }

            Task {
                let result: Result<UIImage?, Error> = await networkRequester.request(url: url, decoder: { data in
                    UIImage(data: data)
                })

                if case let .success(success) = result {
                    image = success
                }
            }
        }
    }
}

#if DEBUG
struct LoadingImage_Previews: PreviewProvider {
    static var previews: some View {
        LoadingImage(url: URL(string: "https://dl5zpyw5k3jeb.cloudfront.net//photos//pets//65042697//1//?bust=1687157611%5Cu0026width%3D100%22,%22medium%22:%22https:%5C/%5C/dl5zpyw5k3jeb.cloudfront.net%5C/photos%5C/pets%5C/65042697%5C/1%5C/?bust%3D1687157611%5Cu0026width%3D300")!) {
            ProgressView()
        }
    }
}
#endif
