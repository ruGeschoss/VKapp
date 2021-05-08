//
//  CharPicker.swift
//  VKapp
//
//  Created by Alexander Andrianov on 17.01.2021.
//

import UIKit
import Foundation

final class CharPicker: UIControl {

  private var maximumChars = Constants.Charpicker.maxChars
  private var stackView: UIStackView!
  var buttons: [UIButton] = []
  
  var chars: [String] = [] {
    didSet {
      restrictCount()
      setupUI()
    }
  }
  var selectedChar: String? = nil {
    didSet {
      updateSelectedChar()
      sendActions(for: .valueChanged)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    stackView.frame = bounds
  }
  
  func setupUI () {
    buttons.removeAll()
    createButtons()
    setupStackView()
  }
  
}

// MARK: - Functions
extension CharPicker {
  
  @objc private func selectChar(_ sender: UIButton) {
    guard let index = buttons.firstIndex(of: sender) else { return }
    
    let char: String = chars[index]
    selectedChar = char
    sender.isSelected = false
  }
  
  private func setupStackView() {
    stackView != nil ?
      (stackView.removeFullyAllArrangedSubviews()) : ()
    
    stackView = UIStackView(arrangedSubviews: buttons)
    stackView.frame = self.bounds
    stackView.axis = .vertical
    stackView.spacing = 5
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
  }
  
  private func createButtons() {
    chars.forEach { (char) in
      let button = UIButton(type: UIButton.ButtonType.system)
      button.setTitle(char, for: .normal)
      button.setTitleColor(.systemPink, for: .normal)
      button.setTitleColor(.systemYellow, for: .selected)
      button.tintColor = UIColor.systemPink
      button.addTarget(self, action: #selector(selectChar),
                       for: .touchUpInside)
      buttons.append(button)
    }
  }
  
  private func updateSelectedChar() {
    for (index, button) in buttons.enumerated() {
      let char: String = chars[index]
      button.isSelected = char == selectedChar
    }
  }
  
  private func restrictCount() {
    if chars.count > maximumChars {
      let step = Float((chars.count * 100) / maximumChars)
      let roundedStep = (step / 100).rounded(.awayFromZero)
      var tmpArr: [String] = []
      chars.enumerated().forEach { (index, char) in
        let shouldAppend = index % Int(roundedStep) == 0
        shouldAppend ? (tmpArr.append(char)) : ()
      }
      self.chars = tmpArr
      setupUI()
    }
  }
}
