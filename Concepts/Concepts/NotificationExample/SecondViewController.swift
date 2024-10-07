//
//  SecondViewController.swift
//  Concepts
//
//  Created by Karthik Reddy on 06/10/24.
//

import UIKit

class SecondViewController: UIViewController {
    
    let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        // Setup label to display the message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        view.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Label constraints
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Observe the notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("DataUpdated"), object: nil)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        // Extract the message from the notification
        print("received in the second VC")
        if let userInfo = notification.userInfo, let message = userInfo["message"] as? String {
            messageLabel.text = message
            print("Notification received with message: \(message)")
        }
    }
    
    deinit {
        // Remove observer when this view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DataUpdated"), object: nil)
    }
}

