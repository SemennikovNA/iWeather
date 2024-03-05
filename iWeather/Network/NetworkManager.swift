//
//  NetworkManager.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import Foundation

class NetworkManager {
    
    //MARK: - Singlton
    
    static let shared = NetworkManager()
    
    //MARK: - Propertie
    
    private let apiKey = "0193dd8e-3f93-48fe-8a05-00d8c8b61a4d"
    private let session = URLSession(configuration: .default)
    
    //MARK: - Initialize
    
    private init() { }
    
    //MARK: - Method
    
    func createURL() -> URL? {
        let url = URL(string:"https://api.weather.yandex.ru/v2/fact")
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("0193dd8e-3f93-48fe-8a05-00d8c8b61a4d", forHTTPHeaderField: "X-Yandex-API-Key")
        request.addValue("0193dd8e-3f93-48fe-8a05-00d8c8b61a4d", forHTTPHeaderField: "X-Yandex-API-Key")
        return url
    }
    
    func fetchData() {
        guard let url = createURL() else { return }
        
        session.dataTask(with: url) { data, response, error in
            guard let data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            guard let response else { return }
            print(data, response)
        }.resume()
    }
    
}

enum HTTPMethod: String {
    
    case get = "GET"
}
