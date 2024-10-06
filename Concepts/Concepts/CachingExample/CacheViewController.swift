//
//  CacheViewController.swift
//  Concepts
//
//  Created by Karthik Reddy on 06/10/24.
//

import UIKit

class CacheViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let imageCache = NSCache<NSString, UIImage>()  // Create an NSCache to store images
    
    let imageURLs: [String] = [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg",
        "https://example.com/image3.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ImageCell")
        
        // TableView Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
        let imageURLString = imageURLs[indexPath.row]
        
        // Reset the cell image
        cell.imageView?.image = nil
        
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: imageURLString as NSString) {
            print("Using cached image for \(imageURLString)")
            cell.imageView?.image = cachedImage
        } else {
            // If not cached, download the image
            downloadImage(from: imageURLString) { [weak self] image in
                guard let self = self, let image = image else { return }
                
                // Cache the image
                self.imageCache.setObject(image, forKey: imageURLString as NSString)
                
                // Reload the table view cell after the image is downloaded
                DispatchQueue.main.async {
                    if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                        cellToUpdate.imageView?.image = image
                        cellToUpdate.setNeedsLayout()  // Trigger layout to resize image properly
                    }
                }
            }
        }
        
        return cell
    }
    
    // Download Image from URL
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image")
                completion(nil)
                return
            }

            completion(image)
        }
        task.resume()
    }
}

