//
//  NetworkManager.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import SVGKit
import Foundation
import Kingfisher

protocol WeatherDataDelegate {
    
    func transferWeatherData(_ networkManager: NetworkManager, data: [WeatherData])
}

class NetworkManager {
    
    //MARK: - Singlton
    
    static let shared = NetworkManager()
    
    //MARK: - Propertie
    
    var delegate: WeatherDataDelegate?
    private let kf = KingfisherManager.shared
    private let session = URLSession(configuration: .default)
    private let decoder = JSONDecoder()
    private let dispatchGroup = DispatchGroup()
    
    var forecastData: [WeatherData] = []
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
    
    let isonsURL: [URLRequest] = [
        Icons.skc_d.requestIsons,
        Icons.skc_n.requestIsons,
        Icons.fg_d.requestIsons,
        Icons.fg_n.requestIsons,
        Icons.bkn_d.requestIsons,
        Icons.bkn_n.requestIsons,
        Icons.bkn__da_d.requestIsons,
        Icons.bkn__ra_n.requestIsons,
        Icons.bkn__sn_d.requestIsons,
        Icons.bkn__sn_n.requestIsons,
        Icons.bkn_ra_d.requestIsons,
        Icons.bkn_ra_n.requestIsons,
        Icons.bkn_sn_d.requestIsons,
        Icons.bkn_sn_n.requestIsons,
        Icons.bkn___ra_d.requestIsons,
        Icons.bkn___ra_n.requestIsons,
        Icons.bkn___sn_d.requestIsons,
        Icons.bkn___sn_n.requestIsons,
        Icons.ovc_ts.requestIsons,
        Icons.ovc_ts_ra.requestIsons,
        Icons.ovc_ts_ha.requestIsons,
        Icons.ovc.requestIsons,
        Icons.ovc___ra.requestIsons,
        Icons.ovc___sn.requestIsons,
        Icons.ovc_ra.requestIsons,
        Icons.ovc_sn.requestIsons,
        Icons.ovc__ra.requestIsons,
        Icons.ovc__sn.requestIsons,
        Icons.ovc_ra_sn.requestIsons,
        Icons.ovc_ha.requestIsons,
        Icons._bl.requestIsons,
        Icons.bl.requestIsons,
        Icons.dst.requestIsons,
        Icons.du_st.requestIsons,
        Icons.smog.requestIsons,
        Icons.strm.requestIsons,
        Icons.vlka.requestIsons
    ]
    
    //MARK: - Initialize
    
    private init() { }
    
    //MARK: - Method
    /// Method fecth data for each cities
    func fetchForEachURL() {
        var weatherData: [WeatherData] = []
        
        self.allURL.forEach { url in
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
    
    /// Method is called from didFinishLaunching and loading icons in cache
    func loadIcons() {
        self.isonsURL.forEach { url in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let urlKey = url.url?.cacheKey else { return }
                self!.session.dataTask(with: url) { data, response, error in
                    guard let data = data else {
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        return
                    }
                    
                    guard let svgImage = SVGKImage(data: data) else {
                        print("Fail transformation data to svg image: \(url)")
                        return
                    }
                    guard let cacheImage = svgImage.uiImage else {
                        print("Fail transformation svg image to UIImage")
                        return
                    }
                    
                    KingfisherManager.shared.cache.store(cacheImage, forKey: urlKey)
                }.resume()
            }
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
