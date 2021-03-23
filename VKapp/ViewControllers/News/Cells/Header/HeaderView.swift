//
//  HeaderView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 22.03.2021.
//

import UIKit

final class HeaderView: UIView {
  // Add action on tap stackView
  @IBOutlet private weak var profileStackView: UIStackView!
  @IBOutlet private weak var avatar: RoundImage!
  @IBOutlet private weak var name: UILabel!
  @IBOutlet private weak var nameUnderLine: UILabel!
  @IBOutlet private weak var menuButton: UIButton!
  
  var contentView: UIView?
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    guard let view = loadViewFromNib() else { return }
    view.frame = self.bounds
    view.backgroundColor = Constants.headerBackgroundColor
    self.addSubview(view)
    contentView = view
  }
  
  private func loadViewFromNib() -> UIView? {
    let nib = Constants.headerViewNib
    let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
    return view
  }
  
  // Configure Header
  func configure(_ avatar: UIImage, _ name: String, _ underLine: String) {
    guard self.avatar != nil,
          self.name != nil,
          nameUnderLine != nil else { return }
    self.avatar.image = avatar
    self.name.text = name
    self.nameUnderLine.text = underLine
  }
  
  @IBAction private func menuButton(_ sender: UIButton) {
    #if DEBUG
    print("Menu button tapped")
    #endif
  }
}
