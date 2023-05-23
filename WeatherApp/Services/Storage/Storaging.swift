import Foundation

protocol Storaging {
    func saveSearch(for ctiy: String)
    func getRecentSearches() -> [String]
}
