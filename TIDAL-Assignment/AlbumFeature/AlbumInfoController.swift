//
//  AlbumController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AlbumInfoController: UITableViewController {
    
    weak var coordinator: AlbumInfoCoordinator?
    
    let album: Album
    
    let infoService: AlbumInfoApiService
    
    var info: AlbumInfoResponse?
    var tracks = [Track]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpTableView()
        
        infoService.getAlbumInfo(album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.info = info
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
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
    }
    
    // MARK: - Init
    
    init(album: Album, service: AlbumInfoApiService) {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.title
        cell.detailTextLabel?.text = String(track.duration)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AlbumInfoController: Coordinated {
    var coordinating: BaseCoordinator? {
        return coordinator
    }
}
