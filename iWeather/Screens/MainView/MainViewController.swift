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
    private var weatherData: [WeatherData]? {
        didSet {
            cityCollection.reloadData()
            hourCollection.reloadData()
        }
    }
    
    //MARK: - User interface element
    
    private let cityView = CityView()
    private var cityCollection = WeatherCollectionView()
    private var hourCollection = WeatherCollectionView()
    private let todayLabel = UILabel(text: "Today", textAlignment: .left, font: UIFont(name: "poppins-medium", size: 20))
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.startAnimating()
        indicator.color = .white
        return indicator
    }()

    //MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        weatherData = []
        
        // Fetch data
        networkManager.fetchForEachURL()
    }
    
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

    //MARK: - Private method
    
    private func setupView() {

        // Setup view
        view.backgroundColor = .backgroundViolet
        view.addSubviews(cityView, cityCollection, activityIndicator, todayLabel, hourCollection)
        
        // Call method's
        setupCityCollection()
        setupHourCollection()
        signatureDelegate()
        setupNavigationBar()
    }
    
    private func signatureDelegate() {
        networkManager.delegate = self
        cityCollection.delegate = self
        cityCollection.dataSource = self
        hourCollection.delegate = self
        hourCollection.dataSource = self
    }
    
    private func setupNavigationBar() {
        let accountBarButton = UIBarButtonItem(image: UIImage(named: "account"), style: .plain, target: self, action: #selector(accountButtonTapped))
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        accountBarButton.tintColor = .white
        menuBarButton.tintColor = .white
        
        navigationItem.backButtonTitle = "Назад"
        navigationItem.leftBarButtonItem = accountBarButton
        navigationItem.rightBarButtonItem = menuBarButton
    }
    
    //MARK: - Objective - C method
    
    @objc func accountButtonTapped() {
        let accountVC = GreenViewController(textLabel: "Hello World!")
        accountVC.modalTransitionStyle = .coverVertical
        accountVC.modalPresentationStyle = .formSheet
        present(accountVC, animated: true)
    }
    
    @objc func menuButtonTapped() {
        let menuVC = GreenViewController(textLabel: "")
        menuVC.modalPresentationStyle = .fullScreen
        menuVC.modalTransitionStyle = .flipHorizontal
        navigationController?.pushViewController(menuVC, animated: true)
    }
}

//MARK: - Extension
//MARK: WeatherDataDelegate
extension MainViewController: WeatherDataDelegate {
    
    func transferWeatherData(_ networkManager: NetworkManager, data: [WeatherData]) {
        self.weatherData = data
        cityCollection.reloadData()
        hourCollection.reloadData()
    }
}

//MARK: Weather collection

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Setup city collection
    private func setupCityCollection() {
        cityCollection.register(CityCollectionCell.self, forCellWithReuseIdentifier: CityCollectionCell.cellID)
        cityCollection.backgroundColor = .clear
        cityCollection.showsHorizontalScrollIndicator = false
        cityCollection.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 15)
    }
    
    // Setup hour collection
    private func setupHourCollection() {
        hourCollection.register(HourCollectionCell.self, forCellWithReuseIdentifier: HourCollectionCell.cellID)
        hourCollection.backgroundColor = .clear
        hourCollection.showsHorizontalScrollIndicator = false
        hourCollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cityCollection {
            guard let data = weatherData else { return 10 }
            return data.count
        } else if collectionView == hourCollection {
            return 10
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let dataForCell = weatherData else {
            return UICollectionViewCell()
        }
        
        if collectionView == cityCollection {
            let cell = cityCollection.dequeueReusableCell(withReuseIdentifier: CityCollectionCell.cellID, for: indexPath) as! CityCollectionCell
            cell.layoutIfNeeded()
            cell.setupCell(with: dataForCell[indexPath.item])
            activityIndicator.stopAnimating()
            return cell
        } else if collectionView == hourCollection {
            let cell = hourCollection.dequeueReusableCell(withReuseIdentifier: HourCollectionCell.cellID, for: indexPath) as! HourCollectionCell
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cityMinimumLineSpacingForSectionAt: CGFloat = 25
        let hourMinimumLineSpacingForSectionAt: CGFloat = 20
        if collectionView == cityCollection {
            return cityMinimumLineSpacingForSectionAt
        } else {
            return hourMinimumLineSpacingForSectionAt
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cityCellSize = CGSize(width: 172, height: 215)
        let hourCellSize = CGSize(width: 76, height: 116)
        if collectionView == cityCollection {
            return cityCellSize
        } else {
            return hourCellSize
        }
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
            
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: cityCollection.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cityCollection.centerYAnchor),

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
