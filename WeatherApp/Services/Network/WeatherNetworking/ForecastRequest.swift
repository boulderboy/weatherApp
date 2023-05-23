import Foundation

struct ForecastRequest: NetworkRequest {
    typealias Response = Weather.Forecast

    private let city: String
    private let days: Int

    var path: String {
        WeatherAPI.Endpoint.forecast.rawValue
    }

    var queryItems: [String: String] {
        [
            "key": WeatherAPI.APIKey,
            "q": city,
            "days": String(describing: days)
        ]
    }

    init(city: String, days: Int) {
        self.city = city
        self.days = days
    }
}
