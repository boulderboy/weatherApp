import Foundation

struct Weather: Codable {
    let location: Location
    let current: Current

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        location = try map.decode(Location.self, forKey: .location)
        current = try map.decode(Current.self, forKey: .current)
    }
}
