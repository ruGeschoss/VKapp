//
//  AsyncAlbumCollection.swift
//  VKapp
//
//  Created by Alexander Andrianov on 10.05.2021.
//

import AsyncDisplayKit

final class AsyncAlbumCollection: ASDKViewController<ASDisplayNode> {
  
  private var fullAlbum: [Photos]
  
  init(album: [Photos]) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 0
    let collectionNode = ASCollectionNode(collectionViewLayout: layout)
    self.fullAlbum = album
    super.init(node: collectionNode)
    collectionNode.dataSource = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension AsyncAlbumCollection: ASCollectionDataSource {
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      numberOfItemsInSection section: Int) -> Int {
    fullAlbum.count
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    let photo = fullAlbum[indexPath.item]
    
    let maxHeight = ceil(collectionNode.frame.width / 3)
    let maxCellHeight = ceil(maxHeight / 2)
    
    let cellNodeBlock = { () -> ASCellNode in
      let cell = AsyncPhotoCell(photo: photo)
      cell.style.preferredSize = CGSize(width: maxCellHeight,
                                        height: maxCellHeight)
      return cell
      }
    return cellNodeBlock
  }
}
