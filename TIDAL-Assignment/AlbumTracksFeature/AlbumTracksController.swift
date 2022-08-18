//
//  AlbumTracksController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AlbumTracksController: UIViewController {
    
    weak var coordinator: AlbumTracksCoordinator?
    
    var viewModel: AlbumTracksViewModelType
    
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
    
    let headerView: CoverHeaderView = {
        let view = CoverHeaderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 52
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AlbumVolumeHeaderView.self, forHeaderFooterViewReuseIdentifier: AlbumVolumeHeaderView.reuseIdentifier)
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        return tableView
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
        setupTableView()
        setupViewModel()
        
        viewModel.start()
        headerView.imageView.loadImage(from: viewModel.albumCover(), placeHolder: UIImage(systemName: "person"))
    }
    
    // MARK: - Init
    
    init(viewModel: AlbumTracksViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        title = viewModel.albumName()
        view.backgroundColor = .tidalDarkBackground
        
        view.addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
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
        
        setAndLayoutTableHeaderView(header: headerView)
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    func setAndLayoutTableHeaderView(header: UIView) {
        tableView.tableHeaderView = header
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            header.heightAnchor.constraint(equalTo: tableView.widthAnchor)
        ])
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size =  header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        tableView.tableHeaderView = header
    }
}

extension AlbumTracksController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfVolumes()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let volumeHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AlbumVolumeHeaderView.reuseIdentifier) as! AlbumVolumeHeaderView
        volumeHeaderView.titleLabel.text = viewModel.volumeNameFor(section: section)
        return volumeHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTracksFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as? TrackCell else {
            return UITableViewCell()
        }
        
        let trackData = viewModel.trackDataFor(path: indexPath)
        trackData.setup(cell, in: tableView, at: indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AlbumTracksController: AlbumTracksViewModelViewDelegate {
    func updateTracks() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func updateState(_ state: ViewControllerState) {
        DispatchQueue.main.async { [weak self] in
            self?.state = state
        }
    }
}

extension AlbumTracksController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
