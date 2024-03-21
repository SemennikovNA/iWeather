// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather

struct WeatherData: Decodable {

    let now: Int
    let nowDt: String
    let info: Info
    let geoObject: GeoObject
    let yesterday: Yesterday
    let fact: Fact
    let forecasts: [Forecast]

    enum CodingKeys: String, CodingKey {
        case now, info
        case nowDt = "now_dt"
        case geoObject = "geo_object"
        case yesterday, fact, forecasts
    }
}

// Информация о текущих условиях
struct Info: Decodable {
    let url: String
    let lat, lon: Double
    let tzinfo: Tzinfo
}

struct GeoObject: Decodable {
    let district, locality, province, country: LocationDetail
}

struct LocationDetail: Decodable {
    let id: Int
    let name: String
}

struct Yesterday: Decodable {
    let temp: Int
}

struct Fact: Decodable {
    let temp, feelsLike: Int
    let icon, condition: String?
    let windSpeed: Double
    let windDir: String
    let pressureMm, humidity: Int
    let uvIndex: Int
    let soilMoisture: Double
    let soilTemp: Int

    enum CodingKeys: String, CodingKey {
        case temp, icon, condition
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case humidity
        case uvIndex = "uv_index"
        case soilMoisture = "soil_moisture"
        case soilTemp = "soil_temp"
    }
}

struct Forecast: Decodable {
    
    let date: String
    let sunrise, sunset: String
    let moonCode: Int
    let moonText: String
    let parts: Parts
    let hours: [Hour]

    enum CodingKeys: String, CodingKey {
        case date, sunrise, sunset
        case moonCode = "moon_code"
        case moonText = "moon_text"
        case parts, hours
    }
}

struct Parts: Decodable {
    let day, dayShort, evening, morning, night, nightShort: PartDetail

    enum CodingKeys: String, CodingKey {
        case day
        case dayShort = "day_short"
        case evening, morning, night
        case nightShort = "night_short"
    }
}

struct PartDetail: Decodable {
    let tempMin, tempAvg, tempMax: Int?
    let windSpeed, windGust: Double?
    let windDir: String?
    let pressureMm, humidity: Int?
    let soilTemp: Int?
    let soilMoisture: Double?
    let precMm: Double?
    let precProb: Int?
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempAvg = "temp_avg"
        case tempMax = "temp_max"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case humidity
        case soilTemp = "soil_temp"
        case soilMoisture = "soil_moisture"
        case precMm = "prec_mm"
        case precProb = "prec_prob"
    }
}

struct Hour: Codable {
    let hour: String
    let hourts: Int
    let temp, feelsLike: Int
    let icon, condition: String
    let windSpeed: Double
    let windDir: String
    let pressureMm, humidity: Int
    let uvIndex: Int
    let soilMoisture: Double
    let soilTemp: Int

    enum CodingKeys: String, CodingKey {
        case hour, temp, icon, condition
        case hourts = "hour_ts"
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case humidity
        case uvIndex = "uv_index"
        case soilMoisture = "soil_moisture"
        case soilTemp = "soil_temp"
    }
}

struct Tzinfo: Decodable {
    let name: String
    let abbr: String
    let dst: Bool
    let offset: Int
}
