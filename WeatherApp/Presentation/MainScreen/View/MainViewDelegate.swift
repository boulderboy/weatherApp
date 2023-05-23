import Foundation

protocol MainViewDelegate: NSObjectProtocol {
    var todayWeather: TodayWeather { get set }
    var currentCity: String {get set}
}
