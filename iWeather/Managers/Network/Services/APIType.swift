//
//  APIType.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import Foundation

enum APIType {

    case moscow
    case saintp
    case nnovgorod
    case kazan
    case samara
    case ufa
    case perm
    case ekat
    case chel
    case omsk
        
    private var baseURL: String {
        
        return "https://api.weather.yandex.ru/v2/"
    }
    
   private var headers: [String: String] {
        
        return ["X-Yandex-API-Key": "0193dd8e-3f93-48fe-8a05-00d8c8b61a4d"]
    }
    
   private var path: String {
        
       switch self {
       case .moscow:
           return "forecast?lat=55.7522&lon=37.6156"
       case .saintp:
           return "forecast?lat=59.9386&lon=30.3141"
       case .nnovgorod:
           return "forecast?lat=56.3287&lon=44.002"
       case .kazan:
           return "forecast?lat=55.7887&lon=49.1221"
       case .samara:
           return "forecast?lat=53.195878&lon=50.100202"
       case .ufa:
           return "forecast?lat=54.7387&lon=55.97206"
       case .perm:
           return "forecast?lat=58.0105&lon=56.2502"
       case .ekat:
           return "forecast?lat=56.8519&lon=60.6122"
       case .chel:
           return "forecast?lat=55.15&lon=61.4"
       case .omsk:
           return "forecast?lat=54.9924&lon=73.3686"
       }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL)!)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        switch self {
        default:
            request.httpMethod = HTTPMethod.get.rawValue
            return request
        }
    }
}


enum HTTPMethod: String {
    
    case get = "GET"
}

enum NetworkError: Error {
    
    case badUrl
    case badRequest
    case badResponse
}
