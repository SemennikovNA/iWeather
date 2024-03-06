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
    
    private let session = URLSession(configuration: .default)
    private let decoder = JSONDecoder()
    
    //MARK: - Initialize
    
    private init() { }
    
    //MARK: - Method
    
    func fetchForEachURL() {
        let _: [URLRequest] = [
            APIType.moscow.request,
            APIType.saintp.request,
            APIType.lownovgorod.request,
            APIType.kazan.request,
            APIType.samara.request,
            APIType.ufa.request,
            APIType.perm.request,
            APIType.ekat.request,
            APIType.chel.request,
            APIType.omsk.request
        ]
        
        let oneUrl = APIType.moscow.request
        
        fetchData(url: oneUrl) { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(_):
                print("failure")
            }
        }
    }
    
    //MARK: - Private method
    
    func fetchData(url: URLRequest, completion: @escaping (Result<WeatherData, NetworkError>) -> ()) {
        session.dataTask(with: url) { [self] data, response, error in
            guard let data = data else {
                if error != nil {
                    completion(.failure(.badResponse))
                }
                return
            }
            
            do {
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(.badResponse))
            }
            print(String(data: data, encoding: .utf8)!)
        }.resume()
    }
}
