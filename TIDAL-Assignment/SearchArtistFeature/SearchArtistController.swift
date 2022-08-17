//
//  SearchArtistController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import UIKit

enum ViewControllerState {
    case content
    case loading
    case error
    case empty
}

class SearchArtistController: UITableViewController {
    
    weak var coordinator: SearchArtistCoordinator?
    
    var viewModel: SearchArtistViewModelType
    
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
        
        viewModel.viewDelegate = self
        viewModel.start()
    }

    // MARK: - Init
    
    init(viewModel: SearchArtistViewModelType) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return viewModel.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        let artist = viewModel.itemFor(row: indexPath.row)
        cell.textLabel?.text = artist.name
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let artist = viewModel.itemFor(row: indexPath.row)
        coordinator?.showArtist(artist)
    }
}

extension SearchArtistController: SearchArtistViewModelViewDelegate {
    func updateScreen() {
        tableView.reloadData()
    }

    func updateState(_ state: ViewControllerState) {
        //self.state = state
    }
}

extension SearchArtistController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.searchFor(text: text)
    }
}

extension SearchArtistController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
