//
//  HourCollection.swift
//  iWeather
//
//  Created by Nikita on 08.03.2024.
//

import UIKit

class HourWeatherCollection: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        // Call method's
        setupHourCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: - Extension
//MARK: Hour collection
extension HourWeatherCollection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
     // Setup hour collection
    private func setupHourCollection() {
        self.register(HourCollectionCell.self, forCellWithReuseIdentifier: HourCollectionCell.cellID)
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        self.delegate = self
        self.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: HourCollectionCell.cellID, for: indexPath) as! HourCollectionCell
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let minimumLineSpacingForSectionAt: CGFloat = 20
        return minimumLineSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 76, height: 116)
        return cellSize
    }
}
