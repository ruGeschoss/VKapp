//
//  NewsCVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.01.2021.
//

import UIKit

class NewsCVC: UICollectionViewCell {
    
    var text:String? {
        didSet {
            self.newsText.text = text
        }
    }
    var image:UIImage? {
        didSet {
            self.newsImage.image = image
        }
    }
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var newsView: UIView!
    
    static let nib = UINib(nibName: "NewsCell", bundle: nil)
    static let identifier = "NewsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI() {
//        ?
    }
    
}
