//
//  FirstViewController.swift
//  Concepts
//
//  Created by Karthik Reddy on 06/10/24.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Setup a button to navigate to SecondViewController
        let button = UIButton(type: .system)
        button.setTitle("Go to Second View Controller", for: .normal)
        button.addTarget(self, action: #selector(navigateToSecondVC), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        // Button constraints
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func navigateToSecondVC() {
        let secondVC = SecondViewController()
        navigationController?.pushViewController(secondVC, animated: true)
        
        // Add a delay before posting the notification
        print("firing with delay")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Post a notification with some data
            NotificationCenter.default.post(name: Notification.Name("DataUpdated"), object: nil, userInfo: ["message": "Hello from FirstViewController!"])
            print("Notification posted after delay!")
        }
    }
}
