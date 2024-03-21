//
//  WeatherCollectionView.swift
//  iWeather
//
//  Created by Nikita on 10.03.2024.
//

import UIKit

class CityCollectionView: UICollectionView {
    
    //MARK: - Initialize
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        // Call method's
        setupCityCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private method
    // Setup city collection
    private func setupCityCollection() {
        self.register(CityCollectionCell.self, forCellWithReuseIdentifier: CityCollectionCell.cellID)
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 15)
    }
}
