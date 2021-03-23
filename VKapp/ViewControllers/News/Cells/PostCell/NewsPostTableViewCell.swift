//
//  NewsPostTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 22.03.2021.
//

import UIKit

final class NewsPostTableViewCell: UITableViewCell {
  @IBOutlet private weak var cellHeaderView: HeaderView!
  @IBOutlet private weak var cellFooterView: FooterView!
  @IBOutlet private weak var cellPostText: UILabel!
  @IBOutlet private weak var cellContentsView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.backgroundColor = Constants.newsCellBackgroundColor
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.cellContentsView.subviews.forEach {
      $0.removeFromSuperview()
      #if DEBUG
      print("SubView removed")
      #endif
    }
  }
  
  override func setSelected(_ selected: Bool,
                            animated: Bool) {
    super.setSelected(false, animated: false)
  }
  
  // MARK: - Configure Header
  func configureHeader(_ headerAvatar: UIImage,
                       _ headerName: String,
                       _ headerUnderline: String) {
    cellHeaderView.configure(headerAvatar,
                         headerName,
                         headerUnderline)
    #if DEBUG
    print("Cell header configured")
    #endif
  }
  
  // MARK: - Configure Footer
  func configureFooter(_ likesCount: String,
                       _ commentsCount: String,
                       _ sharesCount: String,
                       _ viewsCount: String) {
    cellFooterView.configure(likesCount,
                         commentsCount,
                         sharesCount,
                         viewsCount)
    #if DEBUG
    print("Cell footer configured")
    #endif
  }
  
  // MARK: - Configure Content
  func configureContent(_ postText: String?,
                        _ postContent: UIImage?) {
    
    postText != nil ? (cellPostText.text = postText) : ()
    
    guard let postContent = postContent else { return }
    createContentSubview(postContent)
    
    #if DEBUG
    print("Cell content configured")
    #endif
  }
  
  private func createContentSubview(_ postContent: UIImage) {
    let singlePhoto = UIImageView()
    singlePhoto.backgroundColor = .clear
    singlePhoto.image = postContent
    
    singlePhoto.frame = CGRect(
      x: cellContentsView.bounds.minX,
      y: cellContentsView.bounds.minY,
      width: cellContentsView.bounds.width,
      height: cellContentsView.bounds.width)

    self.cellContentsView.contentMode = .scaleToFill
    singlePhoto.contentMode = .scaleAspectFit
    self.cellContentsView.addSubview(singlePhoto)
    setConstraints(for: singlePhoto)
    #if DEBUG
    print("""
          Cell contentsView frame \(cellContentsView.frame)
          Cell contentsView bounds \(cellContentsView.bounds)
          Single photo frame \(singlePhoto.frame)
          Single photo bounds \(singlePhoto.bounds)
          """)
    #endif
  }
  
  private func setConstraints(for imageView: UIImageView) {
    NSLayoutConstraint.activate([
      imageView.topAnchor
        .constraint(equalTo: self.cellContentsView.topAnchor),
      imageView.bottomAnchor
        .constraint(equalTo: self.cellContentsView.bottomAnchor)
    ])
  }
}
