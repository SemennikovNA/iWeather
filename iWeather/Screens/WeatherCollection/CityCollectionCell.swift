//
//  CityCollectionCell.swift
//  iWeather
//
//  Created by Nikita on 07.03.2024.
//

import UIKit

class CityCollectionCell: UICollectionViewCell {
    
    //MARK: - Propertie
    
    static let cellID = "cityCell"
    
    //MARK: - User interface element
    
    private let cityImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "moscow")
        return image
    }()
    private let cityLabel = UILabel(text: "Москва", textAlignment: .center, font: UIFont(name: "poppins-bold", size: 20))
    private let cityTemperature =  UILabel(text: "-15C", textAlignment: .center, font: UIFont(name: "poppins-bold", size: 20))
    
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
        self.layer.cornerRadius = self.frame.size.width / 10
        self.clipsToBounds = true
    }
    
    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        self.addSubviews(contentView)
        contentView.addSubviews(cityImage)
        cityImage.addSubviews(cityLabel, cityTemperature)
        
        // Label's configure
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.minimumScaleFactor = 5
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Content view
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // City image
            cityImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cityImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cityImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // City label
            cityLabel.topAnchor.constraint(equalTo: cityImage.topAnchor, constant: 25),
            cityLabel.leadingAnchor.constraint(equalTo: cityImage.leadingAnchor, constant: 10),
            cityLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // City temperature label
            cityTemperature.topAnchor.constraint(equalTo: cityImage.topAnchor, constant: 27),
            cityTemperature.trailingAnchor.constraint(equalTo: cityImage.trailingAnchor, constant: -10),
            cityTemperature.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
