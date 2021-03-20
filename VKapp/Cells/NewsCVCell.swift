//
//  NewsCVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.01.2021.
//

import UIKit

class NewsCVC: UICollectionViewCell {
  
  @IBOutlet weak var newsText: UILabel!
  @IBOutlet weak var newsView: UIView!
  @IBOutlet weak var photoCollectionView: UICollectionView! {
    didSet {
      photoCollectionView.register(SinglePhotoCVC.nib,
                                   forCellWithReuseIdentifier: SinglePhotoCVC.identifier)
      photoCollectionView.delegate = self
      photoCollectionView.dataSource = self
      photoCollectionView.backgroundColor = .cyan
    }
  }
  
  static let nib = UINib(nibName: "NewsCell", bundle: nil)
  static let identifier = "NewsCell"
  
  private var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []
  private var cellInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  
  var photoForPost: [String]? {
    didSet {
      self.photoCollectionView.reloadData()
    }
  }
  
  var text: String? {
    didSet {
      self.newsText.text = text
      self.newsText.font = UIFont(name: "Courier", size: 17)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.text?.removeAll()
    self.photoForPost?.removeAll()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override class func awakeFromNib() {
    super.awakeFromNib()
    
  }
}

// MARK: - Delegate, DataSource
extension NewsCVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath)
  }
}

extension NewsCVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    photoForPost?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SinglePhotoCVC.identifier,
                                                     for: indexPath) as? SinglePhotoCVC {
      cell.photo = photoForPost![indexPath.item]
      return cell
    }
    return UICollectionViewCell()
  }
}
