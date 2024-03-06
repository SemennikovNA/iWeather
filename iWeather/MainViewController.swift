//
//  MainViewController.swift
//  iWeather
//
//  Created by Nikita on 05.03.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Propertie
    
    private let networkManager = NetworkManager.shared

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call method's
        setupView()
        networkManager.fetchForEachURL()
    }

    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        view.backgroundColor = .brown
    }

}

