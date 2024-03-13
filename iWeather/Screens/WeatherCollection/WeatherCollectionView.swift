//
//  WeatherCollectionView.swift
//  iWeather
//
//  Created by Nikita on 10.03.2024.
//

import UIKit

class WeatherCollectionView: UICollectionView {
    
    //MARK: - Propertie
    
    let hourCell = HourCollectionCell()
    
    //MARK: - Initialize
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
