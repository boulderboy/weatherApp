import Foundation

extension Weather {
    struct Condition: Codable {
        let text: String
        let icon: String
        let code: Code
    }
}

extension Weather.Condition {
    enum Code: Int, Codable {
        case sunnyOrClear = 1000
        case patrlyClody = 1003
        case cloudy = 1006
        case overcast = 1009
        case mist = 1030
        case patchyRain = 1063
        case patchySnow = 1066
        case patchySleet = 1069
        case patchyFreezingDrizzle = 1072
        case thunderyOutbreaks = 1087
        case blowingSnow = 1114
        case blizzard = 1117
        case fog = 1135
        case freezingFog = 1147
        case patchyLightDrizzle = 1150
        case lightDrizzle = 1153
        case freezingDrizzle = 1168
        case heavyFreezingDrizzle = 1171
        case patchyLightRain = 1180
        case lightRain = 1183
        case moderateRainAtTimes = 1186
        case moderateRain = 1189
        case heavyRainAtTimes = 1192
        case heavyRain = 1195
        case lightFreezingRain = 1198
        case heavyFreezingRaing = 1201
        case lightSleet = 1204
        case heavySleet = 1207
        case patchyLightSnow = 1210
        case lightSnow = 1213
        case patchyModerateSnow = 1216
        case moderateSnow = 1219
        case patchyHeavySnow = 1222
        case heavySnow = 1225
        case icePellets = 1237
        case lightRainShower = 1240
        case heavyRainShower = 1243
        case torrentialRainShower = 1246
        case lightSleetShowers = 1249
        case heavySleetShowers = 1252
        case lightSnowShowers = 1255
        case heavySnowShowers = 1258
        case lightShowersOfIcePellets = 1261
        case heavyShowersOfIcePellets = 1264
        case patchyLightRainThunder = 1273
        case heavyRainThunder = 1276
        case patchyLightSnowThunder = 1279
        case heavySnowThunder = 1282
    }
}
