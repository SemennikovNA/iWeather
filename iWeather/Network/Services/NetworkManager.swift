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
    
    func fetchData(completion: @escaping (Result<Data, NetworkError>) -> ()) {
        let urlForFetch = APIType.forecast.request
        
        session.dataTask(with: urlForFetch) { data, response, error in
            guard let data = data else {
                if error != nil {
                    completion(.failure(.badResponse))
                }
                return
            }
           
            
            print(response)
            print(String(data: data, encoding: .utf8)!)
        }.resume()
    }
}
