//
//  CharPicker.swift
//  VKapp
//
//  Created by Alexander Andrianov on 17.01.2021.
//

import UIKit
import Foundation

class CharPicker: UIControl {

    var maximumChars = 15
    var chars: [String] = [] {
        didSet {
            if chars.count > maximumChars {
                let step = Float((chars.count * 100) / maximumChars)
                let roundedStep = (step / 100).rounded(.awayFromZero)
                var tmpArr: [String] = []
                for (index, char) in chars.enumerated() {
                    if index % Int(roundedStep) == 0 {
                        tmpArr.append(char)
                    }
                }
                
                self.chars = tmpArr
                setupUI()
                
                return
            }
        }
    }
    
    var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
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
    
    func setupUI () {
        buttons.removeAll()
        for char in chars {
            let button = UIButton(type: UIButton.ButtonType.system)
            button.setTitle(char, for: .normal)
            button.setTitleColor(.systemPink, for: .normal)
            button.setTitleColor(.systemYellow, for: .selected)
            button.tintColor = UIColor.systemPink
            button.addTarget(self, action: #selector(selectChar), for: .touchUpInside)
            buttons.append(button)
        }
        
        if stackView != nil {
            stackView.removeFullyAllArrangedSubviews()
        }
        
        stackView = UIStackView(arrangedSubviews: buttons)
        stackView.frame = self.bounds
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
    }
    
    @objc func selectChar(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        let char: String = chars[index]
        selectedChar = char
        sender.isSelected = false
    }
    
    private func updateSelectedChar() {
        for (index, button) in buttons.enumerated() {
            let char: String = chars[index]
            button.isSelected = char == selectedChar
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
}

extension UIStackView {

    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
