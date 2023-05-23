import UIKit

struct TodayWeather {
    let date: String
    let temperature: String
    let windSpeed: String
    let humidity: String
    let conditionImage: UIImage?

    static var empty: TodayWeather = {
        TodayWeather(
            date: "--",
            temperature: "-.-",
            windSpeed: "-.-",
            humidity: "--%",
            conditionImage: nil)
    }()
}
