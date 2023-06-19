import Foundation

class NetworkRequester {

    enum RequestType: String {
        case get, post
    }

    let decoder: JSONDecoder

    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }

    func request<T: Decodable>(url: URL, type: RequestType = .get) async -> Result<T, Error> {
        await request(url: url, type: type, request: createRequest(forUrl:type:), decoder: decode(_:))
    }

    func request<T: Decodable>(url: URL,
                               type: RequestType = .get,
                               request: (URL, RequestType) async -> URLRequest) async -> Result<T, Error> {
        await self.request(url: url, type: type, request: request, decoder: decode(_:))
    }

    func request<T>(url: URL,
                    type: RequestType = .get,
                    decoder: (Data) throws -> T) async -> Result<T, Error> {

        await request(url: url, type: type, request: createRequest(forUrl:type:), decoder: decoder)
    }

    func request<T>(url: URL,
                    type: RequestType = .get,
                    request: (URL, RequestType) async -> URLRequest,
                    decoder: (Data) throws -> T) async -> Result<T, Error> {

        let request = await request(url, type)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response.httpResponse

            guard httpResponse?.statusCode == 200 else {
                return .failure(AppError(code: httpResponse?.statusCode ?? -1))
            }

            let bodyObject: T = try decoder(data)

            return .success(bodyObject)

        } catch {
            return .failure(error)
        }
    }

    func createRequest(forUrl url: URL, type: RequestType) async -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = type.rawValue.uppercased()

        return request
    }

    func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
