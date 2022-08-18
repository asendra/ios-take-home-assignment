//
//  AlbumTracksController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AlbumTracksController: UITableViewController {
    
    weak var coordinator: AlbumTracksCoordinator?
    
    let album: Album
    
    let infoService: AlbumTracksApiService
    
    var info: AlbumInfoResponse?
    var tracks = [Track]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let headerView: CoverHeaderView = {
        let view = CoverHeaderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpTableView()
        
        infoService.getTracks(forAlbum: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tracks):
                    self?.tracks = tracks
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        headerView.imageView.loadImage(from: album.coverXL, placeHolder: UIImage(systemName: "person"))
    }
    
    // MARK: - Init
    
    init(album: Album, service: AlbumTracksApiService) {
        self.infoService = service
        self.album = album
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        title = album.title
        view.backgroundColor = .tidalDarkBackground
    }
    
    private func setUpTableView() {
        tableView.register(AlbumVolumeHeaderView.self, forHeaderFooterViewReuseIdentifier: AlbumVolumeHeaderView.reuseIdentifier)
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
            
        setAndLayoutTableHeaderView(header: headerView)
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
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: AlbumVolumeHeaderView.reuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as! TrackCell
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        let track = tracks[indexPath.row]
        cell.positionLabel.text = "\(track.trackPosition)."
        cell.titleLabel.text = track.title
        cell.artistLabel.text = "Lorem ipsum"
        cell.durationLabel.text = String(track.duration)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AlbumTracksController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
