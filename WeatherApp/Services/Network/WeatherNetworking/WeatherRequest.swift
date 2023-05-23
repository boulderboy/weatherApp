import Foundation

struct WeatherRequest: NetworkRequest {
    typealias Response = Weather

    private let city: String

    var path: String {
        WeatherAPI.Endpoint.current.rawValue
    }

    var queryItems: [String: String] {
        [
            "key": WeatherAPI.APIKey,
            "q": city
        ]
    }

    init(city: String) {
        self.city = city
    }
}
