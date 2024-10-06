import UIKit

class SearchViewController: UIViewController {
    private let tableView = UITableView()
    private var searchResults: [String] = []
    private var cache: [String: [String]] = [:]
    private var debounceTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad called")
        
        // Set background color to differentiate view
        view.backgroundColor = .lightGray
        
        setupTableView()
        setupSearchController()
    }

    func setupTableView() {
        view.addSubview(tableView)
        // Use Auto Layout instead of setting frame for better flexibility
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")  // Register cell to reuse
        
        // Customize table view background color for visibility
        tableView.backgroundColor = .white
        
        // Add constraints for the tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupSearchController() {
        print("Setting up search controller")
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Fruits"
        
        // Customize search bar appearance
        searchController.searchBar.barTintColor = .blue
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.tintColor = .black
        
        // Attach searchController to the navigation item
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false  // Ensure the search bar is always visible
        definesPresentationContext = true
    }

    private func performSearch(query: String) {
        print("Performing search with query: \(query)")

        // Check if results are already cached
        if let cachedResults = cache[query] {
            print("Using cached results for query: \(query)")
            self.searchResults = cachedResults
            tableView.reloadData()
            return
        }

        // Ensure the query is URL-encoded
        /// added a dummy api which just returns some values , if we replace it with the api that allows query parameters then the debouncing logic works
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://run.mocky.io/v3/cc577223-ef8e-4c0c-a396-eee592086e76?query=\(encodedQuery)") else {
            print("Invalid URL for query: \(query)")
            return
        }
        print("API call URL: \(url)")

        // Make API request
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error with network request: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let results = try JSONDecoder().decode([String].self, from: data)
                print("API call successful. Results: \(results)")
                DispatchQueue.main.async {
                    // Cache the results
                    self?.cache[query] = results
                    self?.searchResults = results
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        task.resume()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(searchResults.count)")
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        // Customize cell appearance
        cell.backgroundColor = .yellow
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            print("Search query is empty, clearing results")
            searchResults.removeAll()
            tableView.reloadData()
            return
        }

        // Cancel previous debounce timer
        debounceTimer?.invalidate()

        // Set up new debounce timer
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            print("Debounce timer triggered for query: \(query)")
            self?.performSearch(query: query)
        }
    }
}
