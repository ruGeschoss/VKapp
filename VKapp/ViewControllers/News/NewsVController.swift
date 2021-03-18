//
//  NewsVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.01.2021.
//

import UIKit

class NewsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var cellPhotos = [String]()
  let allPhotos = ["photo1",
                   "photo2",
                   "photo3",
                   "photo4",
                   "photo5",
                   "photo6",
                   "photo7",
                   "photo8",
                   "photo9",
                   "photo10"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(HeaderCRV.nib,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: HeaderCRV.identifier)
    collectionView.register(FooterCRV.nib,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: FooterCRV.identifier)
    collectionView.register(NewsCVC.nib,
                            forCellWithReuseIdentifier: NewsCVC.identifier)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCVC.identifier,
                                                     for: indexPath) as? NewsCVC {
      generatePhotoLib(indexPath: indexPath)
      cell.photoForPost = cellPhotos
      cell.text = "Cell for section #\(indexPath.section)"
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "HeaderCRV",
                                                                   for: indexPath) as? HeaderCRV
      header?.userName.text = "Alex"
      header?.userAvatar.image = UIImage(named: "Batz_Maru")
      header?.datePosted.text = "11.11.11 14:0\(indexPath.section)"
      return header ?? UICollectionReusableView()
    } else {
      let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "FooterCRV",
                                                                   for: indexPath) as? FooterCRV
      footer?.configure(viewCount: 78, likeCount: 13, commentCount: 2, shareCount: 5)
      return footer ?? UICollectionReusableView()
    }
  }
  
  func generatePhotoLib(indexPath: IndexPath) {
    cellPhotos = []
    for photo in allPhotos {
      if cellPhotos.count < indexPath.section + 1 {
        cellPhotos.append(photo)
      } else { break }
    }
  }
}

extension NewsVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 44)
    
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 44)
    
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width - 10, height: collectionView.bounds.height * 0.7)
    // MARK: - autoresizing height???
  }
}
