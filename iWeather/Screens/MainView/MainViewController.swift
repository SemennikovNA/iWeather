//
//  MainViewController.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Propertie
    
    private let networkManager = NetworkManager.shared
    private var weatherData: [WeatherData] = []
    
    //MARK: - User interface element
    
    private let cityView = CityView()
    private var cityCollection = CityWeatherCollection()
    private var hourCollection = HourWeatherCollection()
    private let todayLabel = UILabel(text: "Today", textAlignment: .left, font: UIFont(name: "poppins-medium", size: 20))

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call method's
        setupView()
        setupConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cityView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch data
        networkManager.fetchForEachURL()
    }

    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        view.backgroundColor = .backgroundViolet
        view.addSubviews(cityView, cityCollection, todayLabel, hourCollection)
        
        // Call method's
        signatureDelegate()
        setupTargetsForButton()
    }
    
    private func signatureDelegate() {
        networkManager.delegate = self
    }
    
    private func setupTargetsForButton() {
        cityView.addTargetForAccountButton(target: self, selector: #selector(accountButtonTapped))
        cityView.addTargetForMenuButton(target: self, selector: #selector(menuButtonTapped))
    }
    
    //MARK: - Objective - C method
    
    @objc func accountButtonTapped() {
        print("Account")
    }
    
    @objc func menuButtonTapped() {
        print("Burger")
    }

}

//MARK: - Extension
//MARK: WeatherDataDelegate
extension MainViewController: WeatherDataDelegate {
    
    func transferWeatherData(_ networkManager: NetworkManager, data: [WeatherData]) {
        self.weatherData = data
        
        let city = weatherData[0].geoObject.locality.name
        let city1 = weatherData[1].geoObject.locality.name
        let city2 = weatherData[2].geoObject.locality.name
        let city3 = weatherData[3].geoObject.locality.name
        let city4 = weatherData[4].geoObject.locality.name
        let city5 = weatherData[5].geoObject.locality.name
        let city6 = weatherData[6].geoObject.locality.name
        let city7 = weatherData[7].geoObject.locality.name
        let city8 = weatherData[8].geoObject.locality.name
        let city9 = weatherData[9].geoObject.locality.name
        
        print(city, city1, city2, city3, city4, city5, city6, city7, city8, city9, separator: "\n")
    }
}

//MARK: - Private extension
//MARK: Constraints
private extension MainViewController {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // City view
            cityView.topAnchor.constraint(equalTo: self.view.topAnchor),
            cityView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cityView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cityView.heightAnchor.constraint(equalToConstant: 381),

            // City collection
            cityCollection.topAnchor.constraint(equalTo: cityView.bottomAnchor, constant: 15),
            cityCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityCollection.heightAnchor.constraint(equalToConstant: 220),
            
            // Today label
            todayLabel.topAnchor.constraint(equalTo: cityCollection.bottomAnchor, constant: 25),
            todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            todayLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Hour collection
            hourCollection.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 6),
            hourCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hourCollection.heightAnchor.constraint(equalToConstant: 130),
        ])
    }
}
