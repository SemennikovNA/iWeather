//
//  APIType.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import Foundation

enum APIType {
    
    case fact
    case forecast
    
    var baseURL: String {
        return "https://api.weather.yandex.ru/v2/"
    }
    
    var headers: [String: String] {
        
        return ["X-Yandex-API-Key": "0193dd8e-3f93-48fe-8a05-00d8c8b61a4d"]
    }
    
    var path: String {
        
        switch self {
        case .fact: return "fact?"
        case .forecast: return "forecast"
            
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
