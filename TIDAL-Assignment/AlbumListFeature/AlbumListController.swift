//
//  AlbumListController.swift
//  TIDAL-Assignment
//
//  Created by Alberto Sendra Estrella on 16/8/22.
//

import Foundation
import UIKit

class AlbumListController: UIViewController {
    
    weak var coordinator: AlbumListCoordinator?
    
    var viewModel: AlbumListViewModelType
    
    var state = ViewControllerState.empty {
        didSet {
            switch(state) {
            case .loading:
                collectionView.isHidden = true
                messageView.isHidden = true
            case .error(let message):
                collectionView.isHidden = true
                messageView.isHidden = false
                messageView.imageView.image = UIImage(systemName: "exclamationmark.icloud")
                messageView.messageLabel.text = message
            case .content:
                collectionView.isHidden = false
                messageView.isHidden = true
            case .empty:
                collectionView.isHidden = true
                messageView.isHidden = false
                messageView.imageView.image = UIImage(systemName: "magnifyingglass.circle")
                messageView.messageLabel.text = "No albums found for this artist"
            }
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.scrollDirection = .vertical
        
        let itemHeight: CGFloat = 240.0
        let minCellWidth: CGFloat = 150.0
        let minItemSpacing: CGFloat = 10
        let containerWidth: CGFloat = UIScreen.main.bounds.size.width
        let maxCellCountPerRow: CGFloat =  floor((containerWidth - minItemSpacing) / (minCellWidth+minItemSpacing))
        
        let itemWidth: CGFloat = floor(((containerWidth - (2 * minItemSpacing) - (maxCellCountPerRow-1) * minItemSpacing) / maxCellCountPerRow))
        let inset = max(minItemSpacing, floor((containerWidth - (maxCellCountPerRow*itemWidth) - (maxCellCountPerRow-1)*minItemSpacing) / 2))
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = min(minItemSpacing,inset)
        layout.minimumLineSpacing = minItemSpacing
        layout.sectionInset = UIEdgeInsets(top: minItemSpacing, left: inset, bottom: minItemSpacing, right: inset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseIdentifier)
        return collectionView
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
        setupCollectionView()
        setupViewModel()
        
        viewModel.start()
    }
    
    // MARK: - Init
    
    init(viewModel: AlbumListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        title = viewModel.artistName()
        view.backgroundColor = .tidalDarkBackground
        
        view.addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
}

extension AlbumListController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfAlbums()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdentifier, for: indexPath) as? AlbumCell else {
            return UICollectionViewCell()
        }
        
        if viewModel.isLoading(for: indexPath) {
            // TODO: Decide how to handle..
        } else {
            let albumData = viewModel.albumDataFor(row: indexPath.row)
            albumData.setup(cell, in: collectionView, at: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let album = viewModel.albumFor(row: indexPath.row)
        coordinator?.showAlbum(album)
    }
}

extension AlbumListController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoading(for:)) {
            viewModel.fetchMoreAlbums()
        }
    }
}

extension AlbumListController: AlbumListViewModelViewDelegate {
    func updateAlbums(for indexPaths: [IndexPath]?) {
        DispatchQueue.main.async { [weak self] in
            if let paths = indexPaths {
                self?.collectionView.reloadItems(at: paths)
            }
            else {
                self?.collectionView.reloadData()
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
