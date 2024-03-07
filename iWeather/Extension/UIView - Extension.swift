//
//  UIView - Extension.swift
//  iWeather
//
//  Created by Nikita on 07.03.2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ view: UIView...) {
        view.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}
