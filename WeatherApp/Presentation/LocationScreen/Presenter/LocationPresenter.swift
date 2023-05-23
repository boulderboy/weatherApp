import Foundation

final class LocationPresenter {

    weak private var view: LocationViewDelegate?
    private let searchService: SearchServiceProtocol
    private let weatherService: WeatherLoading
    private let storageService: Storaging

    init(searchService: SearchServiceProtocol, weatherService: WeatherLoading, storageService: Storaging) {
        self.searchService = searchService
        self.weatherService = weatherService
        self.storageService = storageService
    }

    func setViewDelegate(to delegate: LocationViewDelegate) {
        self.view = delegate
    }

    func loadRecentSearch() {
        let recentSearch = storageService.getRecentSearches()
        view?.recentSearch = recentSearch
    }

    func saveNewSearch(city: String) {
        storageService.saveSearch(for: city)
    }

    func search(by query: String) {
        searchService.search(by: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.cities = result
            }
        }
    }

    func weather(for cities: [String]) {
        weatherService.weather(forMultiply: cities) { [weak self] result in
            var weatherDictionary = [String: String]()
            for weather in result {
                weatherDictionary[weather.location.name] = "\(weather.current.tempCelsius)"
            }
            DispatchQueue.main.async {
                self?.view?.weatherForCities = weatherDictionary
            }
        }
    }
}
