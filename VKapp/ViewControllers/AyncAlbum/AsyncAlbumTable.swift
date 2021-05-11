//
//  AsyncAlbumTable.swift
//  VKapp
//
//  Created by Alexander Andrianov on 10.05.2021.
//

import AsyncDisplayKit

final class AsyncAlbumTable: ASDKViewController<ASDisplayNode> {
  
  private var tableNode: ASTableNode
  private var albums: [Album]
  private var photos: [Album: [Photos]]
  
  override init() {
    tableNode = ASTableNode()
    albums = []
    photos = [:]
    super.init(node: tableNode)
    tableNode.dataSource = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadAlbums(ownerId: nil)
  }
  
}

// MARK: - Datasource
extension AsyncAlbumTable: ASTableDataSource {
  
  func tableView(_ tableView: UITableView,
                 titleForHeaderInSection section: Int) -> String? {
    albums[section].title
  }

  func tableNode(_ tableNode: ASTableNode,
                 nodeForRowAt indexPath: IndexPath) -> ASCellNode {
    let album = albums[indexPath.section]
    
    guard let fullAlbum = photos[album] else { return ASCellNode() }
    
    let cell = ASCellNode(viewControllerBlock: {
      AsyncAlbumCollection(album: fullAlbum)
    }, didLoad: nil)
    cell.style.preferredSize = CGSize(
      width: tableNode.bounds.width,
      height: tableNode.bounds.width / 3)
    return cell

  }
  
  func tableNode(_ tableNode: ASTableNode,
                 numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    albums.count
  }
}

// MARK: - Func
extension AsyncAlbumTable {
  
  private func loadAlbums(ownerId: String?) {
    NetworkManager.loadAlbums(ownerId: ownerId) { [weak self] albums in
      self?.albums = albums
      
      albums.forEach { album in
        NetworkManager
          .loadPhotos(ownerId: ownerId,
                      albumId: album.albumId,
                      offset: 0,
                      count: 20) { [weak self] photos in
            self?.photos[album] = photos
            self?.tableNode.reloadData()
          }
      }
    }
  }
  
}
