//
//  MainViewController.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import UIKit
import SVGKit
import Kingfisher

class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    private let groupTask = DispatchGroup()
    private let networkManager = NetworkManager.shared
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
    
    private var currentWeather = Fact(temp: 0, feelsLike: 0, icon: "", condition: "", windSpeed: 0, windDir: "", pressureMm: 0, humidity: 0, uvIndex: 0, soilMoisture: 0, soilTemp: 0)
    
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
    private var cityCollection = CityCollectionView()
    private var hourCollection = HourCollectionView()
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
        setupScrollButton()
        signatureDelegate()
        setupNavigationBar()
    }
    
    /// Signature delegates
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
        let hour = hourWeatherData[0]
        let utcTime = hour.hourts
        let currentTime = formattedDateTime(from: utcTime, key: "time")
        let hourIcon = hour.icon
        let keyForImage = "https://yastatic.net/weather/i/icons/funky/light/\(hourIcon).svg"
        let cachedImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: keyForImage)
        cityView.setupDataForView(with: currentItem[0], dayTemperature: temperature, image: getImageName!, formattedDate: formatDate)
        hourCollection.hourCell.setupCell(with: hour, hour: currentTime, image: cachedImage)
        cityActivityIndicator.stopAnimating()
        hourActivityIndicator.stopAnimating()
        hourCollection.reloadData()
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
            return dateFormatter.string(from: date)
        case "time":
            dateFormatter.dateFormat = "hh:mma"
            return dateFormatter.string(from: date)
        default:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
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
        self.currentWeather = self.weatherData[0].fact
        guard !weatherData.isEmpty else { return }
        
        groupTask.leave()
        
        self.groupTask.notify(queue: .main) {
            self.setupCityView()
        }
    }
}

//MARK: Weather collection
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        if collectionView == cityCollection {
            let cell = cityCollection.dequeueReusableCell(withReuseIdentifier: CityCollectionCell.cellID, for: indexPath) as! CityCollectionCell
            let city = weatherData[indexPath.item]
            let getImageName = photoDict[city.geoObject.locality.name]
            cell.setupCell(with: city, image: getImageName!)
            cell.layoutIfNeeded()
            return cell
        } else if collectionView == hourCollection {
            let cell = hourCollection.dequeueReusableCell(withReuseIdentifier: HourCollectionCell.cellID, for: indexPath) as! HourCollectionCell
            let hour = hourWeatherData[indexPath.item]
            let utcTime = hour.hourts
            let currentTime = formattedDateTime(from: utcTime, key: "time")
            let hourIcon = hour.icon
            let keyForImage = "https://yastatic.net/weather/i/icons/funky/light/\(hourIcon).svg"
            let cachedImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: keyForImage)
            cell.setupCell(with: hour, hour: currentTime, image: cachedImage)
            cell.layoutIfNeeded()
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Setup city view
        let currentItem = weatherData
        let formatDate = formattedDateTime(from: weatherData[indexPath.item].now, key: "date")
        let getImageName = photoDict[weatherData[indexPath.item].geoObject.locality.name]
        let temperature = weatherData[indexPath.item].forecasts[0].parts.day
        self.cityView.setupDataForView(with: currentItem[indexPath.item], dayTemperature: temperature, image: getImageName!, formattedDate: formatDate)
        
        // Transit city data to header
        self.currentWeather = currentItem[indexPath.item].fact
        
        // Setup hour collection
        let hourCollectionData = weatherData[indexPath.item].forecasts[0].hours
        self.hourWeatherData.removeAll()
        self.hourWeatherData.append(contentsOf: hourCollectionData)
        self.hourCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReuseView.headerID, for: indexPath) as! HeaderReuseView
        header.layoutIfNeeded()
        let headerData = self.currentWeather
        let keyForImage = "https://yastatic.net/weather/i/icons/funky/light/\(headerData.icon ?? "").svg"
        let cachedImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: keyForImage)
        header.setupHeader(temperature: headerData.temp, timeTitle: "NOW", image: cachedImage)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let hourCollectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        guard collectionView == hourCollection else { return UIEdgeInsets.zero }
        return hourCollectionInsets
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerSize = CGSize(width: 76, height: 116)
        guard collectionView == hourCollection else { return CGSize.zero }
        return headerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cityMinimumLineSpacingForSectionAt: CGFloat = 25
        let hourMinimumLineSpacingForSectionAt: CGFloat = 20
        guard collectionView == cityCollection else { return hourMinimumLineSpacingForSectionAt }
        return cityMinimumLineSpacingForSectionAt
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cityCellSize = CGSize(width: 172, height: 215)
        let hourCellSize = CGSize(width: 76, height: 116)
        guard collectionView == cityCollection else { return hourCellSize }
        return cityCellSize
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
