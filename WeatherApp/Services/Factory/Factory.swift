import Foundation

final class Factory {
    private static let networkClient: Networking = WeatherNetworkClient()

    private static let weatherService: WeatherLoading = WeatherService(
        networkClient: Factory.networkClient
    )

    private static let searchService: SearchServiceProtocol = SearchService(
        networkClient: Factory.networkClient
    )

    private static let storageService: Storaging = StorageService()

    static func mainScreen() -> MainViewController {
        let model = MainModel(weatherService: Factory.weatherService)
        let presenter = MainPresenter(model: model)

        return MainViewController(presenter: presenter)
    }

    static func forecastScreen(location: String) -> ForecastViewController {
        let presenter = ForecastPresenter(weatherService: Factory.weatherService)

        return ForecastViewController(location: location, presenter: presenter)
    }

    static func locationScreen() -> LocationViewController {
        let presenter = LocationPresenter(
            searchService: Factory.searchService,
            weatherService: Factory.weatherService,
            storageService: Factory.storageService
        )

        return LocationViewController(presenter: presenter)
    }
}
