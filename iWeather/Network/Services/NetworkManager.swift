//
//  NetworkManager.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

/*
 "https://api.weather.yandex.ru/v2/forecast?lat=55.7522&lon=37.6156",
 "https://api.weather.yandex.ru/v2/forecast?lat=59.9386&lon=30.3141",
 "https://api.weather.yandex.ru/v2/forecast?lat=56.3287&lon=44.002",
 "https://api.weather.yandex.ru/v2/forecast?lat=55.7887&lon=49.1221",
 "https://api.weather.yandex.ru/v2/forecast?lat=53.195878&lon=50.100202",
 "https://api.weather.yandex.ru/v2/forecast?lat=54.724307&lon=55.964614",
 "https://api.weather.yandex.ru/v2/forecast?lat=58.0105&lon=56.2502",
 "https://api.weather.yandex.ru/v2/forecast?lat=56.8519&lon=60.6122",
 "https://api.weather.yandex.ru/v2/forecast?lat=55.154&lon=61.4291",
 "https://api.weather.yandex.ru/v2/forecast?lat=54.9924&lon=73.3686"
 }
 */

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
        var weatherData: [WeatherData] = []
        for url in allURL {
            self.dispatchGroup.enter()
            DispatchQueue.global().async {
            self.fetchData(url: url) { result in
                switch result {
                case .success(let data):
                    weatherData.append(data)
                case .failure(_):
                    print("Fail")
                }
                self.dispatchGroup.leave()
            }
        }
    }
        dispatchGroup.notify(queue: .main) {
            self.forecastData.append(contentsOf: weatherData)
            self.delegate?.transferWeatherData(self, data: self.forecastData)
        }
    }

    
    //MARK: - Private method
    /// Fetch data
    func fetchData(url: URLRequest, completion: @escaping (Result<WeatherData, NetworkError>) -> ()) {
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                if error != nil {
                    completion(.failure(.badResponse))
                }
                return
            }
            do {
                let weatherData = try self!.decoder.decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(.badResponse))
            }
        }.resume()
    }
}
