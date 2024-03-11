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
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "moscow")
        return image
    }()
    private let cityLabel = UILabel(textAlignment: .left, font: UIFont(name: "poppins-bold", size: 20), numberOfLines: 1)
    private let cityTemperature =  UILabel(textAlignment: .right, font: UIFont(name: "poppins-bold", size: 20))
    
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
    
    //MARK: - Method
    
    func setupCell(with model: WeatherData, image: String) {
        let factTemperature = model.fact.temp
        let textForTemperatureLabel = "\(factTemperature)°C"
        cityLabel.text = model.geoObject.locality.name
        cityTemperature.text = textForTemperatureLabel
        cityImage.image = UIImage(named: image)
    }
    
    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        self.addSubviews(contentView)
        contentView.addSubviews(cityImage)
        cityImage.addSubviews(cityLabel, cityTemperature)
        
        // Label's configure
        cityLabel.minimumScaleFactor = 0.01
        cityLabel.contentScaleFactor = 0.01
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.adjustsFontForContentSizeCategory = true
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
            cityLabel.trailingAnchor.constraint(equalTo: cityTemperature.leadingAnchor),
            cityLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // City temperature label
            cityTemperature.topAnchor.constraint(equalTo: cityImage.topAnchor, constant: 27),
            cityTemperature.trailingAnchor.constraint(equalTo: cityImage.trailingAnchor, constant: -5),
            cityTemperature.heightAnchor.constraint(equalToConstant: 30),
            cityTemperature.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
}
