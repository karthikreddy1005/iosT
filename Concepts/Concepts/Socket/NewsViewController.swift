//
//  NewsViewController.swift
//  Concepts
//
//  Created by Karthik Reddy on 06/10/24.
//

import UIKit

class NewsViewController: UIViewController {
    private var newsWebSocketClient: NewsWebSocketClient?
    
    // UI Element to display news (can be a label, table view, etc.)
    let newsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Waiting for news updates..."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        // Initialize WebSocket Client and connect
        newsWebSocketClient = NewsWebSocketClient()
        newsWebSocketClient?.delegate = self
        newsWebSocketClient?.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Disconnect WebSocket when leaving the view
        newsWebSocketClient?.disconnect()
    }
    
    private func setupUI() {
        view.addSubview(newsLabel)
        newsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setting up auto layout for the label
        NSLayoutConstraint.activate([
            newsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            newsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension NewsViewController: NewsWebSocketClientDelegate {
    func didReceiveNewsUpdate(_ update: String) {
        DispatchQueue.main.async {
            self.newsLabel.text = update
        }
    }
    
    func didFailWithError(_ error: any Error) {
        DispatchQueue.main.async {
            self.newsLabel.text = "Failed to receive news: \(error.localizedDescription)"
        }
    }
}
