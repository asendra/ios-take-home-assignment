//
//  SearchArtistController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import UIKit

class SearchArtistController: UITableViewController {
    
    weak var coordinator: SearchArtistCoordinator?
    
    let searchController: UISearchController = {
        let controller = UISearchController()
        controller.obscuresBackgroundDuringPresentation = false
        controller.showsSearchResultsController = false
        controller.searchBar.placeholder = "Search artist by name"
        controller.searchBar.barStyle = .black
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpSearchController()
        setUpTableView()
    }

    // MARK: - Private
    
    private func setUpUI() {
        title = "Artists"
        view.backgroundColor = .tidalDarkBackground
    }
    
    private func setUpSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    private func setUpTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.textColor = .white
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.showArtist()
    }
}

extension SearchArtistController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print("Search term: " + text)
    }
}

extension SearchArtistController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
