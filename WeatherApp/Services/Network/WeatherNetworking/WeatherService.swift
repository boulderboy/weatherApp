import Foundation

final class WeatherService: WeatherLoading {
    private let networkClient: Networking

    init(networkClient: Networking) {
        self.networkClient = networkClient
    }

    func weather(for city: String, completion: @escaping (Result<Weather?, Error>) -> Void) {
        let request = WeatherRequest(city: city)

        networkClient.dataTask(for: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }?.resume()
    }

    func forecast(
        for city: String,
        days: Int = 10,
        completion: @escaping (Result<Weather.Forecast?, Error>) -> Void
    ) {
        let request = ForecastRequest(city: city, days: days)
        networkClient.dataTask(for: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }?.resume()
    }

    func weather(
        lat: String,
        long: String,
        completion: @escaping (Result<Weather?, Error>) -> Void
    ) {
        let request = WeatherByCoordinatesRequest(lat: lat, long: long)
        networkClient.dataTask(for: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }?.resume()
    }

    func weather(forMultiply cities: [String], completion: @escaping (([Weather]) -> Void)) {
        let group = DispatchGroup()
        var weatherResponses = [Weather]()
        for city in cities {
            group.enter()
            weather(for: city) { result in
                switch result {
                case .success(let weather):
                    guard let weather = weather else { return }
                    weatherResponses.append(weather)
                    group.leave()
                case .failure:
                    print("error")
                }
            }
        }
        group.notify(queue: .main) {
            completion(weatherResponses)
        }
    }
}
