//
//  WeatherCollectionSection.swift
//  iWeather
//
//  Created by Nikita on 07.03.2024.
//

import Foundation

enum WeatherCollectionSection: Int, CustomStringConvertible, CaseIterable {
    
    case cityForecast
    case hourForecast
    
    var description: String {
        switch self {
        case .cityForecast:
            return "cityForecast"
        case .hourForecast:
            return "hourForecast"
        }
    }
}
