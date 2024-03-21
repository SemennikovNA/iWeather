//
//  HeaderReuseView.swift
//  iWeather
//
//  Created by Nikita on 21.03.2024.
//

import UIKit

class HeaderReuseView: UICollectionReusableView {
    
    //MARK: - Propertie
    
    static let headerID = "HeaderView"
    
    //MARK: - User interface element
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundViolet
        return view
    }()
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        return view
    }()
    private let cellImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        image.backgroundColor = .clear
        image.image = UIImage(named: "cloudly")
        return image
    }()
    private let temperatureLabel = UILabel(textAlignment: .center, font: UIFont(name: "poppins-medium", size: 15))
    private let timeLabel = UILabel(text: "Now", textAlignment: .center, font: UIFont(name: "poppins-bold", size: 15))
    
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
        
        headerView.layer.cornerRadius = headerView.frame.size.width / 4
        self.clipsToBounds = true
        cellImageView.layer.cornerRadius = cellImageView.frame.size.width / 4
        self.clipsToBounds = true
    }
    
    //MARK: - Method
    
    func setupHeader(temperature: Int, timeTitle: String, image: UIImage?) {
        let temp = String(temperature)
        timeLabel.text = timeTitle
        temperatureLabel.text = temp
        cellImageView.image = image
    }
    
    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        self.addSubviews(contentView)
        contentView.addSubviews(headerView, timeLabel)
        headerView.addSubviews(cellImageView, temperatureLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Content view
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Cell view
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -35),
            
            // Cell image view
            cellImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
            
            
            // Temperature label
            temperatureLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 3),
            temperatureLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            // Time label
            timeLabel.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
        ])
    }
    
}
