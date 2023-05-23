import UIKit
import MapKit

final class MainPresenter {

    weak private var view: MainViewDelegate?
    private let model: MainModel
    private let locationManager = CLLocationManager()

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        return dateFormatter
    }()

    init(model: MainModel) {
        self.model = model
    }

    func setViewDelegate(delegate: MainViewDelegate?) {
        self.view = delegate
    }

    func weather(for city: String) {
        model.weather(for: city) { weather in
            let todayWeather = self.todayWeather(from: weather)
            self.view?.todayWeather = todayWeather
        }
    }

    func weatherForCurrentLocation() {
        guard let coordinates = locationManager.location?.coordinate else {
            weather(for: "Tbilisi")
            return
        }
        model.weather(lat: String(coordinates.latitude), long: String(coordinates.longitude)) { weather in
            let todayWeather = self.todayWeather(from: weather)
            self.view?.todayWeather = todayWeather
            self.view?.currentCity = weather.location.name
        }
    }

    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }

    private func getImageFor(condition: Weather.Condition.Code) -> UIImage? {
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
        return UIImage(named: imageName)
    }

    private func todayWeather(from weather: Weather) -> TodayWeather {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: weather.current.lastUpdated) ?? Date()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        let dateString = dateFormatter.string(from: date)

        let todayWeather = TodayWeather(
            date: dateString,
            temperature: "\(weather.current.tempCelsius)\u{00B0}",
            windSpeed: "\(weather.current.wind.speedKph) km/h",
            humidity: "\(weather.current.humidity) %",
            conditionImage: getImageFor(condition: weather.current.condition.code))

        return todayWeather
    }
}
