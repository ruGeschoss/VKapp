//
//  NewsVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.01.2021.
//

import UIKit

class NewsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HeaderCRV.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCRV.identifier)
        collectionView.register(FooterCRV.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCRV.identifier)
        collectionView.register(NewsCVC.nib, forCellWithReuseIdentifier: NewsCVC.identifier)
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCVC.identifier, for: indexPath) as? NewsCVC {
            cell.image = UIImage(named: "No_Image")
            cell.text = "Before you go awdawjfjksalfe Before you go awdawjfjksalfe Before you go awdawjfjksalfe Before you go awdawjfjksalfe Before you go awdawjfjksalfe Before you go awdawjfjksalfe Before you go awdawjfjksalfe"
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCRV", for: indexPath) as? HeaderCRV
            header?.userName.text = "Alex"
            header?.userAvatar.image = UIImage(named: "Batz_Maru")
            header?.datePosted.text = "11.11.11 14:08"
            return header ?? UICollectionReusableView()
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterCRV", for: indexPath) as? FooterCRV
            footer?.configure(viewCount: 78, likeCount: 13, commentCount: 2, shareCount: 5)
            return footer ?? UICollectionReusableView()
        }
    }
}

extension NewsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCVC.identifier, for: indexPath) as! NewsCVC
        return CGSize(width: collectionView.bounds.width, height: collectionView.safeAreaLayoutGuide.layoutFrame.height)
        // MARK:- autoresizing height???
    }
}
