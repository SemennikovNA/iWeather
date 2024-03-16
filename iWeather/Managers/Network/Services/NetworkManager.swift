//
//  NetworkManager.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import Foundation
import SVGKit

protocol WeatherDataDelegate {
    
    func transferWeatherData(_ networkManager: NetworkManager, data: [WeatherData])
}

class NetworkManager {
    
    //MARK: - Singlton
    
    static let shared = NetworkManager()
    
    //MARK: - Propertie
    
    var forecastData: [WeatherData] = []
    var delegate: WeatherDataDelegate?
    private let imageCache = ImageCache.shared
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
    
    func loadIcons(for hours: [Hour], completion: @escaping (Result<[String: SVGKImage], Error>) -> Void) {
        var fetchedIcons: [String: SVGKImage] = [:]
        let dispatchGroup = DispatchGroup()
        
            for hour in hours {
                let icon = hour.icon
                guard let url = URL(string: "https://yastatic.net/weather/i/icons/funky/dark/\(icon).svg") else { continue }

                dispatchGroup.enter()
                session.dataTask(with: url) { data, response, error in
                    defer {
                        dispatchGroup.leave()
                    }

                    guard let data = data, error == nil else {
                        completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: nil)))
                        return
                    }

                    if let svgImage = SVGKImage(data: data) {
                        fetchedIcons[icon] = svgImage
                    }
                }.resume()
            }

        dispatchGroup.notify(queue: .main) {
            completion(.success(fetchedIcons))
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
