import Foundation

protocol ForecastPresenterProtocol {
    func setViewProtocol(_ view: ForecastViewProtocol)
    func requestForecast()
}

final class ForecastPresenter: ForecastPresenterProtocol {

    private var view: ForecastViewProtocol?
    private let weatherService: WeatherLoading
    private let dateFormatter = DateFormatter()

    init(weatherService: WeatherLoading) {
        self.weatherService = weatherService
    }

    func setViewProtocol(_ view: ForecastViewProtocol) {
        self.view = view
    }

    func requestForecast() {
        weatherService.forecast(for: view?.location ?? "", days: 10) { result in
            switch result {
            case .success(let forecast):
                guard let forecast = forecast else { return }
                DispatchQueue.main.async {
                    self.view?.forecast = self.forecastViewModel(for: forecast)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func forecastViewModel(for forecast: Weather.Forecast) -> ForecastViewModel {
        var hourlyForecast: [ForecastViewModel.Hour] = []
        var dailyForecast: [ForecastViewModel.Day] = []
        for day in forecast.forecast {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: day.date) ?? Date()
            dateFormatter.dateFormat = "MMM, dd"
            let dateString = dateFormatter.string(from: date).capitalized
            let temperature = "\(day.day.maxtempC)/\(day.day.mintempC)"
            let condition = day.day.condition.code

            let conditionImageName = imageName(for: condition)
            dailyForecast.append(ForecastViewModel.Day(
                date: dateString,
                temperature: temperature,
                conditionImageName: conditionImageName
            ))
        }
        if let hours = forecast.forecast.first?.hour {
            for hour in hours {
                let time = String(hour.time.split(separator: " ")[1])
                let temperature = "\(hour.tempC)"
                let condition = hour.condition.code

                let conditionImageName = imageName(for: condition)
                hourlyForecast.append(ForecastViewModel.Hour(
                    time: time,
                    temperature: temperature,
                    conditionImageName: conditionImageName)
                )
            }
        }
        return ForecastViewModel(hours: hourlyForecast, day: dailyForecast)
    }

    private func imageName(for condition: Weather.Condition.Code) -> String {
        var imageName: String = ""
        switch condition {
        case .sunnyOrClear:
            imageName = "sunny"
        case .patrlyClody:
            imageName = "partlyCloudy"
        case .cloudy:
            imageName = "cloudy"
        case .heavyRain:
            imageName = "rainy"
        case .heavyRainThunder:
            imageName = "thunder"
        default:
            break
        }
        return imageName
    }

}
