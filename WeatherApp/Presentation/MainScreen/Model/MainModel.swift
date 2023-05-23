import Foundation

final class MainModel {
    private let weatherService: WeatherLoading

    init(weatherService: WeatherLoading) {
        self.weatherService = weatherService
    }

    func weather(for city: String, completion: @escaping (Weather) -> Void) {
        weatherService.weather(for: city) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    guard let weather = weather else { return }
                    completion(weather)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func weather(lat: String, long: String, completion: @escaping (Weather) -> Void) {
        weatherService.weather(lat: lat, long: long) { result in
            switch result {
            case .success(let weather):
                guard let weather = weather else { return }
                DispatchQueue.main.async {
                    completion(weather)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
