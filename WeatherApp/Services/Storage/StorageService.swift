import Foundation

final class StorageService: Storaging {
    private enum CellsNames {
        static let recentSearches = "recent searhces"
    }

    let defaults = UserDefaults.standard

    func saveSearch(for city: String) {
        if let savedValues = defaults.object(forKey: CellsNames.recentSearches) as? [String] {
            if savedValues.count < 3 {
                var updated = savedValues
                updated.append(city)
                defaults.set(updated, forKey: CellsNames.recentSearches)
            } else {
                var updated = savedValues
                updated.removeFirst()
                updated.append(city)
                defaults.set(updated, forKey: CellsNames.recentSearches)
            }
        } else {
            defaults.set([city], forKey: CellsNames.recentSearches)
        }
    }

    func getRecentSearches() -> [String] {
        guard let recentSearch = defaults.object(forKey: CellsNames.recentSearches) as? [String]
        else { return [] }
        return recentSearch
    }
}
