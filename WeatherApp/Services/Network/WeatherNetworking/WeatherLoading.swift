import Foundation

protocol WeatherLoading {
    func weather(for city: String, completion: @escaping (Result<Weather?, Error>) -> Void)
    func weather(lat: String, long: String, completion: @escaping (Result<Weather?, Error>) -> Void)
    func weather(forMultiply cities: [String], completion: @escaping (([Weather]) -> Void))
    func forecast(
        for city: String,
        days: Int,
        completion: @escaping (Result<Weather.Forecast?, Error>) -> Void
    )
}
