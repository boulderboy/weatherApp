import Foundation

struct ForecastViewModel {
    var hours: [ForecastViewModel.Hour]
    var day: [ForecastViewModel.Day]

    static let empty = ForecastViewModel(hours: [], day: [])
}

extension ForecastViewModel {
    struct Hour {
        var time: String
        var temperature: String
        var conditionImageName: String
    }

    struct Day {
        var date: String
        var temperature: String
        var conditionImageName: String
    }
}
