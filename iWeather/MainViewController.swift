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
//    private var weatherCollectionView: UICollectionView = {
//        let collection = UICollectionView()
//        return collection
//    }()

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call method's
        setupView()
        setupConstraints()
        signatureDelegate()
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
        view.addSubviews(cityView)
        
        // Setup weather collection view
        setupCollectionView() 
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

//MARK: UICollectionViewCompositionalLayout
extension MainViewController: UICollectionViewDelegate {
    
    // Setup collection view
    private func setupCollectionView() {
//        self.weatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCompositionalLayout())
//        self.weatherCollectionView.delegate = self
//        self.view.addSubviews(weatherCollectionView)
    }
    
    // Setup cell for collection view
    private func registerCellForCompositionalLayout() {
        
    }
    
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = WeatherCollectionSection(rawValue: sectionIndex) else { return nil }
            var section: NSCollectionLayoutSection
            let spacing: CGFloat = 10
            switch sectionKind {
            case .cityForecast:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(327), heightDimension: .absolute(124))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: spacing, leading: 18, bottom: spacing, trailing: spacing)
                section.interGroupSpacing = 5
                section.contentInsetsReference = .layoutMargins
                
                return section
                
            case .hourForecast:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(327), heightDimension: .absolute(124))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: spacing, leading: 18, bottom: spacing, trailing: spacing)
                section.interGroupSpacing = 5
                section.contentInsetsReference = .layoutMargins
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.pinToVisibleBounds = false
                header.zIndex = 2
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
    }
}

//MARK: - Private extension
//MARK: Constraints
private extension MainViewController {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cityView.topAnchor.constraint(equalTo: self.view.topAnchor),
            cityView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cityView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cityView.heightAnchor.constraint(equalToConstant: 415),
            
            
            
        ])
    }
}
