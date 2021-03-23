//
//  FooterView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 22.03.2021.
//

import UIKit

final class FooterView: UIView {
  @IBOutlet private weak var likesCount: UILabel!
  @IBOutlet private weak var commentsCount: UILabel!
  @IBOutlet private weak var sharesCount: UILabel!
  @IBOutlet private weak var viewsCount: UILabel!
  
  var contentView: UIView?
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    guard let view = loadViewFromNib() else { return }
    view.frame = self.bounds
    view.backgroundColor = Constants.footerBackgroundColor
    self.addSubview(view)
    contentView = view
  }
  
  private func loadViewFromNib() -> UIView? {
    let nib = Constants.footerViewNib
    let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
    return view
  }
  
  func configure(_ likesCount: String,
                 _ commentsCount: String,
                 _ sharesCount: String,
                 _ viewsCount: String ) {
    self.likesCount.text = likesCount
    self.commentsCount.text = commentsCount
    self.sharesCount.text = sharesCount
    self.viewsCount.text = viewsCount
  }
  
  @IBAction private func likeButton(_ sender: UIButton) {
    #if DEBUG
    print("Like button tapped")
    #endif
  }
  @IBAction private func commentButton(_ sender: UIButton) {
    #if DEBUG
    print("Comment button tapped")
    #endif
  }
  @IBAction private func shareButton(_ sender: UIButton) {
    #if DEBUG
    print("Share button tapped")
    #endif
  }
  
}
