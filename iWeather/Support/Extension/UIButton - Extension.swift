//
//  UIButton - Extension.swift
//  iWeather
//
//  Created by Nikita on 11.03.2024.
//

import UIKit

extension UIButton {
     

    convenience init(image: String, title: String = "", target: Any, action: Selector) {
        self.init(frame: .infinite)
        self.setImage(UIImage(named: image), for: .normal)
        self.setTitle(title, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
