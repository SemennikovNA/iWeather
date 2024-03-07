//
//  CityView.swift
//  iWeather
//
//  Created by Nikita on 07.03.2024.
//

import UIKit

class CityView: UIView {
    
    //MARK: - User interface element
    
    
    //MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Call method'd
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
//        self.layer.maskedCorners =
    }
    //MARK: - Private method
    
    private func setupView() {
        self.backgroundColor = .backgroundCity
    }
    
}
