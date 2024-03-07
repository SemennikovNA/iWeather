//
//  NetworkManager.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import Foundation

protocol WeatherDataDelegate {
    
    func transferWeatherData(_ networkManager: NetworkManager, data: [WeatherData])
}

class NetworkManager {
    
    //MARK: - Singlton
    
    static let shared = NetworkManager()
    
    //MARK: - Propertie
    var forecastData: [WeatherData] = []
    var delegate: WeatherDataDelegate?
    private let session = URLSession(configuration: .default)
    private let decoder = JSONDecoder()
    private let dispatchGroup = DispatchGroup()
    let allURL: [URLRequest] = [
        APIType.moscow.request,
        APIType.saintp.request,
        APIType.nnovgorod.request,
        APIType.kazan.request,
        APIType.samara.request,
        APIType.ufa.request,
        APIType.perm.request,
        APIType.ekat.request,
        APIType.chel.request,
        APIType.omsk.request
    ]
    
    
    //MARK: - Initialize
    
    private init() { }
    
    //MARK: - Method
    
    func fetchForEachURL() {
        
        for url in allURL {
            self.dispatchGroup.enter()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.fetchData(url: url) { result in
                    switch result {
                    case .success(let data):
                        self.forecastData.append(contentsOf: data)
                    case .failure(_):
                        print("Fail")
                    }
                    self.dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.delegate?.transferWeatherData(self, data: self.forecastData)
        }
    }
    
    //MARK: - Private method
    /// Fetch data
    func fetchData(url: URLRequest, completion: @escaping (Result<[WeatherData], NetworkError>) -> ()) {
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                if error != nil {
                    completion(.failure(.badResponse))
                }
                return
            }
//            print(String(data: data, encoding: .utf8))
            do {
                let weatherData = try self!.decoder.decode(WeatherData.self, from: data)
                self!.forecastData.append(weatherData)
                completion(.success(self!.forecastData))
            } catch {
                completion(.failure(.badResponse))
            }
        }.resume()
    }
}
