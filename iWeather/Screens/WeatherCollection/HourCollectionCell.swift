//
//  HourCollectionCell.swift
//  iWeather
//
//  Created by Nikita on 08.03.2024.
//

import UIKit


class HourCollectionCell: UICollectionViewCell {
    
    //MARK: - User interface element
    
    
    
    
    //MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Call method's
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        self.layer.cornerRadius = self.frame.size.width / 5
        self.clipsToBounds = true
    }
    
    //MARK: - Method
    
    func setupCell(with model: String) {
        
    }
    
    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        self.addSubviews(contentView)
        contentView.addSubviews()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
