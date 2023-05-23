import Foundation

// swiftlint:disable nesting
extension Weather {
    struct Current: Codable {
        enum CodingKeys: String, CodingKey {
            case lastUpdated = "last_updated"
            case tempCelsius = "temp_c"
            case tempFahrenheit = "temp_f"
            case humidity
            case isDay = "is_day"
            case condition
        }

        let lastUpdated: String
        let tempCelsius: Double
        let tempFahrenheit: Double
        let humidity: Int
        @BoolFromInt var isDay: Bool
        let condition: Condition
        let wind: Wind

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
            self.tempCelsius = try container.decode(Double.self, forKey: .tempCelsius)
            self.tempFahrenheit = try container.decode(Double.self, forKey: .tempFahrenheit)
            self.humidity = try container.decode(Int.self, forKey: .humidity)
            self._isDay = try container.decode(BoolFromInt.self, forKey: .isDay)
            self.condition = try container.decode(Weather.Condition.self, forKey: .condition)

            wind = try Wind(from: decoder)
        }
    }
}
