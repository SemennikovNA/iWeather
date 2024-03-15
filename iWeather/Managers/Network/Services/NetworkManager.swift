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
    var hourIcons: [Hour] = []
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
    
    func fetchIcons(for names: [String], completion: @escaping ([String: SVGKImage]) -> Void) {
        var iconsDict: [String: SVGKImage] = [:]
        let dispatchGroup = DispatchGroup()
        
        for iconName in names {
            guard let iconURL = URL(string: "https://yastatic.net/weather/i/icons/funky/light/\(iconName).svg") else { continue }
            
            dispatchGroup.enter()
            session.dataTask(with: iconURL) { data, response, error in
                defer { dispatchGroup.leave() }
                
                guard let data = data, error == nil else {
                    print("Error fetching icon: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let svgImage = SVGKImage(data: data)
                    iconsDict[iconName] = svgImage
                } catch {
                    print("Error decoding icon: \(error)")
                }
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(iconsDict)
        }
    }


//"https://yastatic.net/weather/i/icons/funky/light/\(name).svg"
    
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
