//
//  LikeButtonUIButton.swift
//  VKapp
//
//  Created by Александр Андрианов on 05.01.2021.
//

import UIKit

class LikeButtonUIButton: UIButton {
    
    var likesCount:UInt = 0
    var alreadyLiked:Bool = false
    
    let preLikeImage:UIImage? = UIImage(systemName: "heart")
    let preLikeColor:UIColor = UIColor.gray
    var preLikeText:String = ""
    
    let afterLikeImage:UIImage? = UIImage(systemName: "heart.fill")
    let afterLikeColor:UIColor = UIColor.red
    var afterLikeText:String = ""
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setTitle(String(likesCount), for: .normal)
        self.setTitleColor(preLikeColor, for: .normal)
        self.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    @objc func onTap() {
        alreadyLiked = !alreadyLiked
        if alreadyLiked {
            likeImage()
        } else {
            dislikeImage()
        }
        
    }
    
    func likeImage() {
        likesCount += 1
        afterLikeText = String(likesCount)
        self.setImage(afterLikeImage, for: .normal)
        self.setTitle(afterLikeText, for: .normal)
        self.setTitleColor(afterLikeColor, for: .normal)
    }
    
    func dislikeImage() {
        likesCount -= 1
        preLikeText = String(likesCount)
        self.setImage(preLikeImage, for: .normal)
        self.setTitle(preLikeText, for: .normal)
        self.setTitleColor(preLikeColor, for: .normal)
    }
}
