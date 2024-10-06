//
//  SettingsViewController.swift
//  Concepts
//
//  Created by Karthik Reddy on 06/10/24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen // Background color for settings screen
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "Settings Screen"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
