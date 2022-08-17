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
    
    var state = ViewControllerState.empty {
        didSet {
            print("Updated state = \(state)")
            tableView.reloadData()
        }
    }
    
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
        
        setupUI()
        setupSearchController()
        setupTableView()
        setupViewModel()
        
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
    
    private func setupUI() {
        title = "Artists"
        view.backgroundColor = .tidalDarkBackground
    }
    
    private func setupSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    private func setupTableView() {
        tableView.prefetchDataSource = self
        tableView.register(ArtistCell.self, forCellReuseIdentifier: ArtistCell.reuseIdentifier)
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfArtists()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistCell.reuseIdentifier, for: indexPath) as? ArtistCell else {
            return UITableViewCell()
        }
        
        if viewModel.isLoading(for: indexPath) {
            // TODO: Decide how to handle..
        } else {
            let artistData = viewModel.artistDataFor(row: indexPath.row)
            artistData.setup(cell, in: tableView, at: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let artist = viewModel.artistFor(row: indexPath.row)
        coordinator?.showArtist(artist)
    }
}

extension SearchArtistController: SearchArtistViewModelViewDelegate {
    func updateArtists(for indexPaths: [IndexPath]?) {
        DispatchQueue.main.async { [weak self] in
            if let paths = indexPaths {
                self?.tableView.reloadRows(at: paths, with: .automatic)
            }
            else {
                self?.tableView.reloadData()
            }
        }
    }

    func updateState(_ state: ViewControllerState) {
        DispatchQueue.main.async { [weak self] in
            self?.state = state
        }
    }
}

extension SearchArtistController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoading(for:)) {
            viewModel.fetchMoreArtists()
        }
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
