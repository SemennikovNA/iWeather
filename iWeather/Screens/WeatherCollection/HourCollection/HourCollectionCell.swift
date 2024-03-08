//
//  HourCollectionCell.swift
//  iWeather
//
//  Created by Nikita on 08.03.2024.
//

import UIKit


class HourCollectionCell: UICollectionViewCell {
    
    //MARK: - Propertie
    
    static let cellID = "hourCell"
    
    //MARK: - User interface element
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        return view
    }()
    private let cellImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        image.image = UIImage(named: "cloudly")
        image.clipsToBounds = true
        return image
    }()
    private let temperatureLabel = UILabel(text: "-15°C", textAlignment: .center, font: UIFont(name: "poppins-medium", size: 15))
    
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
        
        self.layer.cornerRadius = self.frame.size.width / 4
        self.clipsToBounds = true
    }
    
    //MARK: - Method
    
    func setupCell(with model: String) {
        
    }
    
    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        self.addSubviews(contentView)
        contentView.addSubviews(cellView)
        cellView.addSubviews(cellImageView, temperatureLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Content view
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Cell view
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Cell image view
            cellImageView.topAnchor.constraint(equalTo: cellView.topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -20),
            
            
            // Temperature label
            temperatureLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -11),
            temperatureLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            
        ])
    }
}
