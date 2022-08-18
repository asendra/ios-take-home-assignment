//
//  SearchArtistController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import UIKit

class SearchArtistController: UIViewController {
    
    weak var coordinator: SearchArtistCoordinator?
    
    var viewModel: SearchArtistViewModelType
    
    var state = ViewControllerState.empty {
        didSet {
            switch(state) {
            case .loading:
                tableView.isHidden = true
                messageView.isHidden = true
            case .error(let message):
                tableView.isHidden = true
                messageView.isHidden = false
                messageView.imageView.image = UIImage(systemName: "exclamationmark.icloud")
                messageView.messageLabel.text = message
            case .content:
                tableView.isHidden = false
                messageView.isHidden = true
            case .empty:
                tableView.isHidden = true
                messageView.isHidden = false
                messageView.imageView.image = UIImage(systemName: "magnifyingglass.circle")
                messageView.messageLabel.text = "Search for your favourite artists"
            }
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 52
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArtistCell.self, forCellReuseIdentifier: ArtistCell.reuseIdentifier)
        return tableView
    }()
    
    let searchController: UISearchController = {
        let controller = UISearchController()
        controller.obscuresBackgroundDuringPresentation = false
        controller.showsSearchResultsController = false
        controller.searchBar.placeholder = "Search artist by name"
        controller.searchBar.barStyle = .black
        return controller
    }()
    
    let messageView: TableMessageView = {
        let view = TableMessageView(frame: .zero)
        view.backgroundColor = .clear
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        title = "Artists"
        view.backgroundColor = .tidalDarkBackground
        
        view.addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
}

extension SearchArtistController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfArtists()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let artist = viewModel.artistFor(row: indexPath.row)
        coordinator?.showArtist(artist)
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

extension SearchArtistController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
