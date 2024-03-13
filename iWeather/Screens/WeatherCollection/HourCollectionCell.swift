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
    let imageManager = ImageManager.shared
    
    //MARK: - User interface element
    
    private let cellView: UIView = {
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
        
        cellView.layer.cornerRadius = cellView.frame.size.width / 4
        cellView.clipsToBounds = true
        cellImageView.layer.cornerRadius = cellImageView.frame.size.width / 4
        cellImageView.clipsToBounds = true
    }
    
    //MARK: - Method
    
    func setupCell(with model: Hour, hour: String) {
        let temp = model.temp
        timeLabel.text = hour
        temperatureLabel.text = "\(temp)"
    }
    
    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        self.addSubviews(contentView)
        contentView.addSubviews(cellView, timeLabel)
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
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35),
            
            // Cell image view
            cellImageView.topAnchor.constraint(equalTo: cellView.topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -15),
            
            
            // Temperature label
            temperatureLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 3),
            temperatureLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            
            // Time label
            timeLabel.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
    }
}
