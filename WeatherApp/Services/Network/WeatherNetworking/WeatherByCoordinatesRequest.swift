import Foundation

struct WeatherByCoordinatesRequest: NetworkRequest {
    typealias Response = Weather

    private let lat: String
    private let long: String

    var path: String {
        WeatherAPI.Endpoint.current.rawValue
    }

    var queryItems: [String: String] {
        [
            "key": WeatherAPI.APIKey,
            "q": lat + "," + long
        ]
    }

    init(lat: String, long: String) {
        self.lat = lat
        self.long = long
    }
}
