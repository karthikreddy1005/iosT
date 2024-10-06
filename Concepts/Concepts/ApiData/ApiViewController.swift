//
//  ApiViewController.swift
//  Concepts
//
//  Created by Karthik Reddy on 06/10/24.
//

import UIKit

class ApiViewController: UIViewController {

    var data = [Todo]()
    var arr: String?
    
    // Initialize the tableView
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Call to setup the tableViewxxJ
        setupTableView()
        
        // Fetch the data
        fetchingApiData(URL: "https://jsonplaceholder.typicode.com/todos") { result in
            DispatchQueue.main.async {
                self.data = result
                self.tableView.reloadData() // Reload tableView after fetching data
            }
        }
    }
    
    // Method to fetch API data
    func fetchingApiData(URL url: String, completion: @escaping([Todo]) -> Void ) {
        let url = URL(string: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if data != nil && error == nil {
                do {
                    let parsingData = try JSONDecoder().decode([Todo].self, from: data!)
                    completion(parsingData)
                } catch {
                    print("Parsing error")
                }
            }
        }
        dataTask.resume()
    }
    
    // Method to setup the tableView
    func setupTableView() {
        view.addSubview(tableView)
        
        // Set the delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register a basic UITableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "apicell")
        
        // Add constraints to the tableView to make it fill the screen
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ApiViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // Configure the cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apicell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        return cell
    }
}
