//
//  UILabel - Extension.swift
//  iWeather
//
//  Created by Nikita on 08.03.2024.
//

import UIKit

extension UILabel {
    
    convenience init(text: String?, textColor: UIColor = UIColor.white, textAlignment: NSTextAlignment, font: UIFont?, numberOfLines: Int = 0) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.font = font
        self.numberOfLines = numberOfLines
    }
}
