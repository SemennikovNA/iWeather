//
//  WeatherCollectionSection.swift
//  iWeather
//
//  Created by Nikita on 07.03.2024.
//

import UIKit

class WeatherCollection: UICollectionView {
    
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
