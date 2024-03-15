//
//  MainViewController.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import UIKit
import SVGKit

class MainViewController: UIViewController {
    
    //MARK: - Propertie
    
    private let networkManager = NetworkManager.shared
    private let groupTask = DispatchGroup()
    private var icons: [String: SVGKImage] = [:]
    private var weatherData: [WeatherData] = [] {
        didSet {
            cityCollection.reloadData()
        }
    }
    private var hourWeatherData: [Hour] = [] {
        didSet {
            hourCollection.reloadData()
        }
    }
    private let photoDict: [String: String] = [
        "Москва": "moscow",
        "Санкт-Петербург": "snp",
        "Нижний Новгород": "nnovgorod",
        "округ Уфа": "ufa",
        "Казань": "kazan",
        "округ Самара": "samara",
        "Пермь": "perm",
        "Екатеринбург": "ekat",
        "округ Челябинск": "chel",
        "Омск": "omsk"
    ]
    
    //MARK: - User interface element
    
    private let cityView = CityView()
    private var cityCollection = WeatherCollectionView()
    private var hourCollection = WeatherCollectionView()
    private let todayLabel = UILabel(text: "Today", textAlignment: .left, font: UIFont(name: "poppins-medium", size: 20))
    private let cityActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.startAnimating()
        indicator.color = .white
        return indicator
    }()
    private let hourActivityIndicator: UIActivityIndicatorView = {
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
    /// Setup main view
    private func setupView() {
        // Setup view
        view.backgroundColor = .backgroundViolet
        view.addSubviews(cityView, cityCollection, cityActivityIndicator, todayLabel, hourCollection, hourActivityIndicator)
        
        // Enabled touch in hour collection
        hourCollection.allowsSelection = false
        hourCollection.allowsMultipleSelection = false
        
        // Call method's
        setupCityCollection()
        setupHourCollection()
        signatureDelegate()
        setupNavigationBar()
    }
    
    /// Signature delegates for collection's
    private func signatureDelegate() {
        networkManager.delegate = self
        cityCollection.delegate = self
        cityCollection.dataSource = self
        hourCollection.delegate = self
        hourCollection.dataSource = self
    }
    
    /// Setup navigation bar
    private func setupNavigationBar() {
        let accountBarButton = UIBarButtonItem(image: UIImage(named: "account"), style: .plain, target: self, action: #selector(accountButtonTapped))
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        accountBarButton.tintColor = .white
        menuBarButton.tintColor = .white
        
        navigationItem.backButtonTitle = "Назад"
        navigationItem.leftBarButtonItem = accountBarButton
        navigationItem.rightBarButtonItem = menuBarButton
    }
    
    /// Setup scroll button for hour collection
    private func setupScrollButton() {
        let scrollButton = UIButton(image: "arrow", target: self, action: #selector(scrollRightButtonTapped))
        hourCollection.addSubviews(scrollButton)
        
        // Scroll button constraints
        scrollButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2).isActive = true
        scrollButton.centerYAnchor.constraint(equalTo: hourCollection.centerYAnchor, constant: -22).isActive = true
    }
    
    /// Setup first item in weather data for city view
    private func setupCityView() {
        let currentItem = weatherData
        let formatDate = formattedDateTime(from: weatherData[0].now, key: "date")
        let getImageName = photoDict[weatherData[0].geoObject.locality.name]
        let temperature = weatherData[0].forecasts[0].parts.day
        let hourData = weatherData[0].forecasts[0].hours
        self.hourWeatherData = hourData
        cityView.setupDataForView(with: currentItem[0], dayTemperature: temperature, image: getImageName!, formattedDate: formatDate)
    }
    
    /// This method returns a formatted date with the day of the week or time.
    /// Keys:
    /// Date - "date"
    /// Time - "time"
    private func formattedDateTime(from timestamp: Int, key: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        switch key {
        case "date":
            dateFormatter.dateFormat = "dd MMM EEE"
        case "time":
            dateFormatter.dateFormat = "hh:mma"
        default:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    //MARK: - Objective - C method
    /// Target for account button
    @objc func accountButtonTapped() {
        let accountVC = GreenViewController(textLabel: "Hello World!")
        accountVC.modalTransitionStyle = .coverVertical
        accountVC.modalPresentationStyle = .formSheet
        present(accountVC, animated: true)
    }
    
    /// Target for menu button
    @objc func menuButtonTapped() {
        let menuVC = GreenViewController(textLabel: "")
        menuVC.modalPresentationStyle = .fullScreen
        menuVC.modalTransitionStyle = .flipHorizontal
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
    /// Target for scroll button for hour collection
    @objc func scrollRightButtonTapped() {
        let cellWidth: CGFloat = 200
        let currentOffset = hourCollection.contentOffset
        let newOffset = CGPoint(x: currentOffset.x + cellWidth, y: currentOffset.y)
        
        let rightEdge = hourCollection.contentSize.width - hourCollection.bounds.width
        if currentOffset.x < rightEdge {
            hourCollection.setContentOffset(newOffset, animated: true)
        }
    }
}

//MARK: - Extension
//MARK: WeatherDataDelegate
extension MainViewController: WeatherDataDelegate {
    
    func transferWeatherData(_ networkManager: NetworkManager, data: [WeatherData]) {
        self.groupTask.enter()
        
        self.weatherData = data
        guard !weatherData.isEmpty else { return }
        
        groupTask.leave()
        
        self.groupTask.notify(queue: .main) {
            self.cityCollection.reloadData()
            self.hourCollection.reloadData()
            self.setupCityView()
            
            // Загрузка иконок
            let iconNames = self.weatherData.flatMap { weather in
                weather.forecasts.flatMap { forecast in
                    let hourIcons = forecast.hours.compactMap { $0.icon }
                    return hourIcons
                }
            }
            self.networkManager.fetchIcons(for: iconNames) { iconsDict in
                self.icons = iconsDict
                print(self.icons)
            }
        }
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
        hourCollection.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 15)
        setupScrollButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cityCollection {
            return weatherData.count
        } else if collectionView == hourCollection {
            return hourWeatherData.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cityData = weatherData
        let hourData = hourWeatherData
        
        if collectionView == cityCollection {
            let cell = cityCollection.dequeueReusableCell(withReuseIdentifier: CityCollectionCell.cellID, for: indexPath) as! CityCollectionCell
            cell.layoutIfNeeded()
            let getImageName = photoDict[cityData[indexPath.item].geoObject.locality.name]
            cell.setupCell(with: cityData[indexPath.item], image: getImageName!)
            cityActivityIndicator.stopAnimating()
            return cell
        } else if collectionView == hourCollection {
            let cell = hourCollection.dequeueReusableCell(withReuseIdentifier: HourCollectionCell.cellID, for: indexPath) as! HourCollectionCell
            hourActivityIndicator.stopAnimating()
            let utcTime = hourData[indexPath.item].hourts
            let hourImage = icons[weatherData[indexPath.item].forecasts[0].hours[0].icon]
            let currentTime = formattedDateTime(from: utcTime, key: "time")
            cell.setupCell(with: hourData[indexPath.item], hour: currentTime, image: hourImage)
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Setup city view
        let currentItem = weatherData
        let formatDate = formattedDateTime(from: weatherData[indexPath.item].now, key: "date")
        let getImageName = photoDict[weatherData[indexPath.item].geoObject.locality.name]
        let temperature = weatherData[indexPath.item].forecasts[0].parts.day
        self.cityView.setupDataForView(with: currentItem[indexPath.item], dayTemperature: temperature, image: getImageName!, formattedDate: formatDate)
        
        // Setup hour collection
        let hourCollectionData = weatherData[indexPath.item].forecasts[0].hours
        self.hourWeatherData.removeAll()
        self.hourWeatherData.append(contentsOf: hourCollectionData)
        self.hourCollection.reloadData()
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
            
            // City activity indicator
            cityActivityIndicator.centerXAnchor.constraint(equalTo: cityCollection.centerXAnchor),
            cityActivityIndicator.centerYAnchor.constraint(equalTo: cityCollection.centerYAnchor),
            
            // City collection
            cityCollection.topAnchor.constraint(equalTo: cityView.bottomAnchor, constant: 15),
            cityCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityCollection.heightAnchor.constraint(equalToConstant: 220),
            
            // Today label
            todayLabel.topAnchor.constraint(equalTo: cityCollection.bottomAnchor, constant: 25),
            todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            todayLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Hour activity indicator
            hourActivityIndicator.centerYAnchor.constraint(equalTo: hourCollection.centerYAnchor),
            hourActivityIndicator.centerXAnchor.constraint(equalTo: hourCollection.centerXAnchor),
            
            // Hour collection
            hourCollection.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 6),
            hourCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hourCollection.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
}
