import Foundation

// swiftlint:disable nesting
extension Weather {
    struct Wind: Codable {
        enum CodingKeys: String, CodingKey {
            case speedMph = "wind_mph"
            case speedKph = "wind_kph"
            case degree = "wind_degree"
            case direction = "wind_dir"
        }

        let speedMph: Double
        let speedKph: Double
        let degree: Double
        let direction: String

        init(from decoder: Decoder) throws {
            let map = try decoder.container(keyedBy: CodingKeys.self)

            speedMph = try map.decode(Double.self, forKey: .speedMph)
            speedKph = try map.decode(Double.self, forKey: .speedKph)
            degree = try map.decode(Double.self, forKey: .degree)
            direction = try map.decode(String.self, forKey: .direction)
        }
    }
}
