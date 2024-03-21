//
//  HourCollectionView.swift
//  iWeather
//
//  Created by Nikita on 21.03.2024.
//

import UIKit

class HourCollectionView: UICollectionView {
    
    //MARK: - Properties
    
    let hourCell = HourCollectionCell()
    
    //MARK: - Initialize
    
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
    
    //MARK: - Private method
    // Setup hour collection
    private func setupHourCollection() {
        self.register(HourCollectionCell.self, forCellWithReuseIdentifier: HourCollectionCell.cellID)
        self.register(HeaderReuseView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReuseView.headerID)
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 15)
    }
}
