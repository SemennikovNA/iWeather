//
//  CollectionHeaderView.swift
//  iWeather
//
//  Created by Nikita on 11.03.2024.
//

import UIKit

final class CollectionHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    
    static let reuseIdentifire = "HeaderReuseIdentifire"
    
    //MARK: - User interface elements
    
    private lazy var headerTitleLabel = UILabel(textAlignment: .left, font: UIFont(name: "poppins-medium", size: 20))
    
    //MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Call method's
        setupHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    func setupHeader(textTitle: String) {
        headerTitleLabel.text = textTitle
    }

    //MARK: - Private method
    /// Setup header view
    private func setupHeaderView() {
        self.addSubviews(headerTitleLabel)
        NSLayoutConstraint.activate([
            headerTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
    }
}
