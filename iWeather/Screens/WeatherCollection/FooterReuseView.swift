//
//  HeaderReuseView.swift
//  iWeather
//
//  Created by Nikita on 07.03.2024.
//

import UIKit

class FooterReuseView: UICollectionReusableView {
    
    //MARK: - User interface element
    
    var titleLabel = UILabel()
    
    //MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Call method's
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        self.addSubviews(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        ])
    }
}
