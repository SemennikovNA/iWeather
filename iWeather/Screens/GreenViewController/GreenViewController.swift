//
//  MenuViewController.swift
//  iWeather
//
//  Created by Nikita on 10.03.2024.
//

import UIKit

class GreenViewController: UIViewController {
    
    //MARK: - User interface element
    
    private let helloWorldLabel = UILabel(textColor: .white, textAlignment: .center, font: UIFont(name: "poppins-bold", size: 40), numberOfLines: 0)
    
    //MARK: - Initialize
    
    init(textLabel: String) {
        super.init(nibName: nil, bundle: nil)
        self.helloWorldLabel.text = textLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Call method's
        setupView()
    }

    //MARK: - Private method
    
    private func setupView() {
        // Setup view
        view.backgroundColor = .systemGreen
        view.addSubviews(helloWorldLabel)
        
        NSLayoutConstraint.activate([
            // Hello world label
            helloWorldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloWorldLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
