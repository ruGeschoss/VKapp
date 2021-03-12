//
//  loadingProcessView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 24.01.2021.
//

import UIKit

class LoadingProcessView: UIView {

    @IBOutlet weak var loadingProcess: UIView!
    @IBOutlet weak var rightDot: UIView!
    @IBOutlet weak var leftDot: UIView!
    @IBOutlet weak var centerDot: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        loadingProcess.backgroundColor = .clear
        leftDot.backgroundColor = .white
        centerDot.backgroundColor = .white
        rightDot.backgroundColor = .white
        
        leftDot.layer.cornerRadius = leftDot.frame.height / 2
        centerDot.layer.cornerRadius = centerDot.frame.height / 2
        rightDot.layer.cornerRadius = rightDot.frame.height / 2
    }
    func animate() {
        UIView.animate(withDuration: 0.45, delay: 0, options: [.repeat,.autoreverse,.curveEaseInOut], animations: {
            self.leftDot.layer.opacity = 0
        })
        UIView.animate(withDuration: 0.45, delay: 0.15, options: [.repeat,.autoreverse,.curveEaseInOut], animations: {
            self.centerDot.layer.opacity = 0
        })
        UIView.animate(withDuration: 0.45, delay: 0.3, options: [.repeat,.autoreverse,.curveEaseInOut], animations: {
            self.rightDot.layer.opacity = 0
        })
    }

}
