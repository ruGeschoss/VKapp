//
//  SinglePhotoCVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 04.02.2021.
//

import UIKit

class SinglePhotoCVC: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    static let nib = UINib(nibName: "SinglePhotoCVCell", bundle: nil)
    static let identifier = "singlePhotoCell"
    
    var photo : String? {
        didSet {
            self.photoImageView.image = UIImage(named: photo!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
