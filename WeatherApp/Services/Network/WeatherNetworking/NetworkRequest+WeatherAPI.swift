import Foundation

public extension NetworkRequest {
    var scheme: HTTPScheme {
        .https
    }

    var host: String {
        WeatherAPI.baseURL
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String: String] {
        [:]
    }

    var body: [String: String]? {
        nil
    }
}
