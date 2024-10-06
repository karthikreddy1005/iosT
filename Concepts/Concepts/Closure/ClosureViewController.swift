// ClosureViewController.swift
// Concepts
//
// Created by Karthik Reddy on 06/10/24.
//

import UIKit

struct ApiResponse: Codable {
    let title: String
    let body: String
}

class ClosureViewController: UIViewController {
    
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        setupUI()
        
        // Fetch the post
        fetchPost { [weak self] data in
            print("Inside the fetch post method in viewDidLoad")
            DispatchQueue.main.async {
                if let post = data {
                    self?.titleLabel.text = post.title
                    self?.bodyLabel.text = post.body
                } else {
                    self?.titleLabel.text = "Failed to fetch post"
                }
            }
        }
    }
    
    private func setupUI() {
        // Set up the UI elements
        titleLabel.numberOfLines = 0 // Allow for multiple lines
        bodyLabel.numberOfLines = 0   // Allow for multiple lines
        
        // Set text color for visibility
        titleLabel.textColor = .black
        bodyLabel.textColor = .black
        
        // Set a background color for visibility
        view.backgroundColor = .white
        
        // Add the labels to the view
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        
        // Set up constraints (using Auto Layout)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func fetchPost(completion: @escaping (ApiResponse?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let post = try decoder.decode(ApiResponse.self, from: data)
                completion(post) // Call completion with the decoded post
                print("successfully fetched and passed data to the elements in view did load")
            } catch {
                print("Error decoding the API response: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}
