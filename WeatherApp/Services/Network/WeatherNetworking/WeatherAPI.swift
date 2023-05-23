import Foundation

enum WeatherAPI {
    static let baseURL = "api.weatherapi.com"
    static let APIKey = "1bd2005b3b074b6ca4c101854232305"
}

extension WeatherAPI {
    enum Endpoint: String {
        case current
        case forecast
        case search

        var rawValue: String {
            switch self {
            case .current:
                return "/v1/\(Path.current.rawValue).json"
            case .forecast:
                return "/v1/\(Path.forecast.rawValue).json"
            case .search:
                return "/v1/\(Path.search.rawValue).json"
            }
        }
    }

    private enum Path: String {
        case current
        case forecast
        case search
    }
}
