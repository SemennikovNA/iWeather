//
//  SDWebImage.swift
//  iWeather
//
//  Created by Nikita on 12.03.2024.
//

import UIKit
import SDWebImage

final class ImageManager {
    
    //MARK: - Singleton
    
    static let shared = ImageManager()
    
    //MARK: - Initialize
    
    private init() { }
    
    //MARK: - Method
    
    func setImageFromURL(view: UIImageView, url: URL) {
        view.sd_setImage(with: url)
    }
}
