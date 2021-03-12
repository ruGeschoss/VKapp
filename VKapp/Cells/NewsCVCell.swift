//
//  NewsCVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.01.2021.
//

import UIKit

class NewsCVC: UICollectionViewCell {
    
    var photoForPost = [String]()
    var cellInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var text:String? {
        didSet {
            self.newsText.text = text
            self.newsText.font = UIFont(name: "Courier", size: 17)
        }
    }
    
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    static let nib = UINib(nibName: "NewsCell", bundle: nil)
    static let identifier = "NewsCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        photoCollectionView.register(SinglePhotoCVC.nib, forCellWithReuseIdentifier: SinglePhotoCVC.identifier)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
}

extension NewsCVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoForPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SinglePhotoCVC.identifier, for: indexPath) as? SinglePhotoCVC {
            cell.photo = photoForPost[indexPath.item]
            return cell
        } else {
            return UICollectionViewCell() }
    }
}

extension NewsCVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.bounds.width
        let avaliableHeight = collectionView.bounds.height
        
        switch photoForPost.count {
        case 1:
            return CGSize(width: availableWidth, height: avaliableHeight)
        case 2:
            return CGSize(width: availableWidth, height: avaliableHeight / 2)
        case 3:
            if indexPath.item == 0 {
                return CGSize(width: availableWidth, height: avaliableHeight / 2)
            } else {
                return CGSize(width: availableWidth / 2, height: avaliableHeight / 2)
            }
        case 4:
            return CGSize(width: availableWidth / 2, height: avaliableHeight / 2)
        case 5:  // first 2 at top, next 3 at bottom
            if indexPath.item == 0 || indexPath.item == 1 {
                return CGSize(width: availableWidth / 2, height: avaliableHeight / 2)
            } else {
                return CGSize(width: (availableWidth / 3) - 0.01, height: (avaliableHeight / 2) - 0.01)
            }
        case 6: // first big at top left, others fill
            if indexPath.item == 0 {
                return CGSize(width: (availableWidth * 2 / 3) - 0.01, height: (avaliableHeight * 2 / 3) - 0.01)
            } else {
                return CGSize(width: (availableWidth / 3) - 0.01, height: (avaliableHeight / 3) - 0.01)
            }
        default:
            return CGSize(width: availableWidth / CGFloat(photoForPost.count), height: avaliableHeight / CGFloat(photoForPost.count))
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        cellInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        cellInsets.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        cellInsets.left
    }
}
