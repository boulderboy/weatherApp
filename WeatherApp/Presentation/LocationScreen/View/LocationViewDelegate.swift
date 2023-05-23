import Foundation

protocol LocationViewDelegate: NSObjectProtocol {
    var cities: [Weather.Location] { get set }
    var recentSearch: [String] {get set}
    var weatherForCities: [String: String] {get set}
}
