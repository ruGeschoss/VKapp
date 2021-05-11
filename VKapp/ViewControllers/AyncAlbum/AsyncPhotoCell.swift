//
//  AsyncPhotoCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 10.05.2021.
//

import AsyncDisplayKit

final class AsyncPhotoCell: ASCellNode {
  
  private var image: ASNetworkImageNode
  private var photo: Photos
  
  init(photo: Photos) {
    self.photo = photo
    
    image = ASNetworkImageNode()
    image.contentMode = .scaleAspectFill
    image.url = URL(string: photo.imageUrl.last!)
    super.init()
    
    self.automaticallyManagesSubnodes = true
    let width = style.preferredSize.width
    let height = style.preferredSize.height
    self.style.width = ASDimension(unit: .points, value: width)
    self.style.height = ASDimension(unit: .points, value: height)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let insets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    return ASInsetLayoutSpec(insets: insets, child: image)
  }
}
