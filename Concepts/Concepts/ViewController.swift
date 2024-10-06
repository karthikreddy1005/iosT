//
//  ViewController.swift
//  Concepts
//
//  Created by Karthik Reddy on 05/10/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearrchBar: UISearchBar!
    let carData = ["Ford", "Mercedes", "Audi", "BMW", "Lambhorghini", "Ferrari"]
    var filteredData: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = carData
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == "" {
            filteredData = carData
        }
        for word in carData {
            if word.uppercased().contains(searchText.uppercased()) {
                filteredData.append(word)
            }
        }
        self.tableView.reloadData()
    }
}
