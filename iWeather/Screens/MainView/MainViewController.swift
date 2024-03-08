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
    private var cityCollection = WeatherCollection()
    private let todayLabel = UILabel(text: "Today", textAlignment: .left, font: UIFont(name: "poppins-medium", size: 20))
    private var hourCollection = WeatherCollection()

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call method's
        setupView()
        setupConstraints()
        signatureDelegate()
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
        view.addSubviews(cityView, todayLabel)
        
        // Setup collection's
        setupCityCollection()
    }
    
    private func signatureDelegate() {
        networkManager.delegate = self
    }

}

//MARK: - Extension
//MARK: WeatherDataDelegate
extension MainViewController: WeatherDataDelegate {
    
    func transferWeatherData(_ networkManager: NetworkManager, data: [WeatherData]) {
        self.weatherData = data
    }
}

//MARK: City collection

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Setup city collection 
    private func setupCityCollection() {
        cityCollection.register(CityCollectionCell.self, forCellWithReuseIdentifier: CityCollectionCell.cellID)
        cityCollection.backgroundColor = .clear
        cityCollection.showsHorizontalScrollIndicator = false
        cityCollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cityCollection.delegate = self
        cityCollection.dataSource = self
        view.addSubviews(cityCollection)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cityCollection.dequeueReusableCell(withReuseIdentifier: CityCollectionCell.cellID, for: indexPath) as! CityCollectionCell
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 172, height: 215)
        return cellSize
    }
    
}

//MARK: Hour collection

extension MainViewController {
    
    // Setup hour collection
    private func setupHourCollection() {
        
        hourCollection.backgroundColor = .clear
        hourCollection.showsHorizontalScrollIndicator = false
        hourCollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        hourCollection.delegate = self
        hourCollection.dataSource = self
        view.addSubviews(hourCollection)
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
            cityCollection.topAnchor.constraint(equalTo: cityView.bottomAnchor, constant: 30),
            cityCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityCollection.heightAnchor.constraint(equalToConstant: 220),
            
            // Today label
            todayLabel.topAnchor.constraint(equalTo: cityCollection.bottomAnchor, constant: 25),
            todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            todayLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
