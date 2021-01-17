//
//  CharPicker.swift
//  VKapp
//
//  Created by Александр Андрианов on 17.01.2021.
//

import UIKit

class CharPicker: UIControl {

    var chars:[String] = []
    private var buttons:[UIButton] = []
    private var stackView:UIStackView!
    
    var selectedChar:String? = nil {
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
        for char in chars {
            let button = UIButton(type: UIButton.ButtonType.system)
            button.setTitle(char, for: .normal)
            button.setTitleColor(.systemPink, for: .normal)
            button.setTitleColor(.systemYellow, for: .selected)
            button.addTarget(self, action: #selector(selectChar), for: .touchUpInside)
            buttons.append(button)
        }
        stackView = UIStackView(arrangedSubviews: buttons)
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.distribution = .fillEqually
    }
    
    @objc func selectChar(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender),
              let char: String? = chars[index]
        else { return }
        selectedChar = char
    }
    
    private func updateSelectedChar() {
        for (index, button) in buttons.enumerated() {
            guard let char: String? = chars[index] else { return }
            button.isSelected = char == selectedChar
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}