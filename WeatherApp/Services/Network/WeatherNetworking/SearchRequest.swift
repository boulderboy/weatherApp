import Foundation

struct SearchRequest: NetworkRequest {
    typealias Response = [Weather.Location]

    var path: String {
        WeatherAPI.Endpoint.search.rawValue
    }

    private let searchPrefix: String

    var queryItems: [String: String] {
        [
            "key": WeatherAPI.APIKey,
            "q": searchPrefix
        ]
    }

    init(searchPrefix: String) {
        self.searchPrefix = searchPrefix
    }
}
