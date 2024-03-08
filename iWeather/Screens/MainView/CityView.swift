//
//  CityView.swift
//  iWeather
//
//  Created by Nikita on 07.03.2024.
//

import UIKit

class CityView: UIView {
    
    //MARK: - User interface element
    
    private let accountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        button.setImage(UIImage(named: "account"), for: .normal)
        return button
    }()
    private let menuButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        button.setImage(UIImage(named: "burger"), for: .normal)
        return button
    }()
    private let cityImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "moscow")
        return image
    }()
    private let cityLabel = UILabel(text: "Moscow", textAlignment: .center, font: UIFont(name: "poppins-bold", size: 28))
    private let temperatureLabel = UILabel(text: "-15°C", textAlignment: .center, font: UIFont(name: "poppins-bold", size: 36))
    private let weatherDescription = UILabel(text: "Clear sky", textAlignment: .center, font: UIFont(name: "poppins-regular", size: 21.33))
    private let dayLabel = UILabel(text: "8 Mar Fri 20°C/29°C", textAlignment: .center, font: UIFont(name: "poppins-regular", size: 21.91))
    
    //MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Call method'd
        setupView()
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.width / 15
        self.clipsToBounds = true
    }
    
    //MARK: - Method
    
    func addTargetForAccountButton(target: Any, selector: Selector) {
        accountButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    func addTargetForMenuButton(target: Any, selector: Selector) {
        menuButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        self.addSubviews(cityImage, accountButton, menuButton)
        self.backgroundColor = .backgroundCity
        
        // Setup image view
        cityImage.addSubviews(cityLabel, temperatureLabel, weatherDescription, dayLabel)
    }
    
    private func setupConstraits() {
        NSLayoutConstraint.activate([
            //Account button
            accountButton.topAnchor.constraint(equalTo: cityImage.safeAreaLayoutGuide.topAnchor),
            accountButton.leadingAnchor.constraint(equalTo: cityImage.leadingAnchor, constant: 22),
            accountButton.heightAnchor.constraint(equalToConstant: 34),
            accountButton.widthAnchor.constraint(equalToConstant: 34),
            
            // Menu button
            menuButton.topAnchor.constraint(equalTo: cityImage.safeAreaLayoutGuide.topAnchor),
            menuButton.trailingAnchor.constraint(equalTo: cityImage.trailingAnchor, constant: -27),
            menuButton.heightAnchor.constraint(equalToConstant: 34),
            menuButton.widthAnchor.constraint(equalToConstant: 34),
            
            // City image
            cityImage.topAnchor.constraint(equalTo: self.topAnchor),
            cityImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cityImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cityImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // City label
            cityLabel.topAnchor.constraint(equalTo: cityImage.topAnchor, constant: 169),
            cityLabel.leadingAnchor.constraint(equalTo: cityImage.leadingAnchor, constant: 25),
            
            // Temperature label
            temperatureLabel.topAnchor.constraint(equalTo: cityImage.topAnchor, constant: 162),
            temperatureLabel.trailingAnchor.constraint(equalTo: cityImage.trailingAnchor, constant: -25),
            
            // Weather description
            weatherDescription.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 14),
            weatherDescription.trailingAnchor.constraint(equalTo: cityImage.trailingAnchor, constant: -25),
            
            // Day label
            dayLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 7),
            dayLabel.leadingAnchor.constraint(equalTo: cityImage.leadingAnchor, constant: 25),
            
        ])
    }
}
