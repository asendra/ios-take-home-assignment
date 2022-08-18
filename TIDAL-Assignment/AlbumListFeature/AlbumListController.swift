//
//  AlbumListController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AlbumListController: UITableViewController {
    
    weak var coordinator: AlbumListCoordinator?
    
    var viewModel: AlbumListViewModelType
    
    var state = ViewControllerState.empty {
        didSet {
            print("Updated state = \(state)")
            switch(state) {
            case .loading:
                tableView.isHidden = true
                //messageView.isHidden = true
            case .error(_):
                tableView.isHidden = true
                //messageView.isHidden = false
                //messageView.imageView.image = UIImage(systemName: "exclamationmark.icloud")
                //messageView.messageLabel.text = message
            case .content:
                tableView.isHidden = false
                //messageView.isHidden = true
            case .empty:
                tableView.isHidden = true
                //messageView.isHidden = false
                //messageView.imageView.image = UIImage(systemName: "magnifyingglass.circle")
                //messageView.messageLabel.text = "Search for your favourite artists"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpTableView()
        setupViewModel()
        
        viewModel.start()
    }
    
    // MARK: - Init
    
    init(viewModel: AlbumListViewModelType) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        title = viewModel.artistName()
        view.backgroundColor = .tidalDarkBackground
    }
    
    private func setUpTableView() {
        tableView.prefetchDataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfAlbums()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        if viewModel.isLoading(for: indexPath) {
            // TODO: Decide how to handle..
        } else {
            let album = viewModel.albumFor(row: indexPath.row)
            cell.textLabel?.text = album.title
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = viewModel.albumFor(row: indexPath.row)
        coordinator?.showAlbum(album)
    }
}

extension AlbumListController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoading(for:)) {
            viewModel.fetchMoreAlbums()
        }
    }
}

extension AlbumListController: AlbumListViewModelViewDelegate {
    func updateAlbums(for indexPaths: [IndexPath]?) {
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

extension AlbumListController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
