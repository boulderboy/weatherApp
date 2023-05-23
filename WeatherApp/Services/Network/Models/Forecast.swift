import Foundation

// swiftlint:disable identifier_name
// swiftlint:disable nesting

extension Weather {
    struct Forecast: Codable {
        let location: Location
        let current: Current
        let forecast: [ForecastDay]

        init(from decoder: Decoder) throws {
            let map = try decoder.container(keyedBy: CodingKeys.self)

            location = try map.decode(Location.self, forKey: .location)
            current = try map.decode(Current.self, forKey: .current)

            let container = try map.decode(ForecastContainer.self, forKey: .forecast)
            forecast = container.forecastday
        }
    }

    private struct ForecastContainer: Codable {
        let forecastday: [Weather.Forecast.ForecastDay]
    }
}

extension Weather.Forecast {
    struct ForecastDay: Codable {
        let date: String
        let day: Day
        let hour: [Weather.Hour]
    }
}

extension Weather {
    // MARK: - Hour
    struct Hour: Codable {
        let timeEpoch: Int
        let time: String
        let tempC, tempF: Double
        @BoolFromInt var isDay: Bool
        let condition: Condition
        let windMph, windKph: Double
        let windDegree: Int
        let windDir: String
        let pressureMB: Int
        let pressureIn, precipMm, precipIn: Double
        let humidity, cloud: Int
        let feelslikeC, feelslikeF, windchillC, windchillF: Double
        let heatindexC, heatindexF, dewpointC, dewpointF: Double
        let willItRain, chanceOfRain, willItSnow, chanceOfSnow: Int
        let visKM, visMiles: Double
        let gustMph, gustKph: Double
        let uv: Int

        enum CodingKeys: String, CodingKey {
            case timeEpoch = "time_epoch"
            case time
            case tempC = "temp_c"
            case tempF = "temp_f"
            case isDay = "is_day"
            case condition
            case windMph = "wind_mph"
            case windKph = "wind_kph"
            case windDegree = "wind_degree"
            case windDir = "wind_dir"
            case pressureMB = "pressure_mb"
            case pressureIn = "pressure_in"
            case precipMm = "precip_mm"
            case precipIn = "precip_in"
            case humidity, cloud
            case feelslikeC = "feelslike_c"
            case feelslikeF = "feelslike_f"
            case windchillC = "windchill_c"
            case windchillF = "windchill_f"
            case heatindexC = "heatindex_c"
            case heatindexF = "heatindex_f"
            case dewpointC = "dewpoint_c"
            case dewpointF = "dewpoint_f"
            case willItRain = "will_it_rain"
            case chanceOfRain = "chance_of_rain"
            case willItSnow = "will_it_snow"
            case chanceOfSnow = "chance_of_snow"
            case visKM = "vis_km"
            case visMiles = "vis_miles"
            case gustMph = "gust_mph"
            case gustKph = "gust_kph"
            case uv
        }
    }
}

extension Weather.Forecast {
    struct Day: Codable {
        let maxtempC, maxtempF, mintempC, mintempF: Double
        let avgtempC, avgtempF, maxwindMph, maxwindKph: Double
        let totalprecipMm, totalprecipIn: Double
        let totalsnowCM: Int
        let avgvisKM: Double
        let avgvisMiles, avghumidity, dailyWillItRain, dailyChanceOfRain: Int
        let dailyWillItSnow, dailyChanceOfSnow: Int
        let condition: Weather.Condition
        let uv: Int

        enum CodingKeys: String, CodingKey {
            case maxtempC = "maxtemp_c"
            case maxtempF = "maxtemp_f"
            case mintempC = "mintemp_c"
            case mintempF = "mintemp_f"
            case avgtempC = "avgtemp_c"
            case avgtempF = "avgtemp_f"
            case maxwindMph = "maxwind_mph"
            case maxwindKph = "maxwind_kph"
            case totalprecipMm = "totalprecip_mm"
            case totalprecipIn = "totalprecip_in"
            case totalsnowCM = "totalsnow_cm"
            case avgvisKM = "avgvis_km"
            case avgvisMiles = "avgvis_miles"
            case avghumidity
            case dailyWillItRain = "daily_will_it_rain"
            case dailyChanceOfRain = "daily_chance_of_rain"
            case dailyWillItSnow = "daily_will_it_snow"
            case dailyChanceOfSnow = "daily_chance_of_snow"
            case condition, uv
        }
    }
}
