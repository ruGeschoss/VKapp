//
//  FriendPhotoCollectionViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import RealmSwift

class FriendPhotoCollectionViewController: UICollectionViewController {

    var currentImageIndex = 0
    let photoPerRow: CGFloat = 3
    let cellInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var photosForUserID = String()      // id of user
    var allPhotosOfUser = [Photos]()    // detailed photo info (if needed more info) unused
    var allPhotosUrls = [List<String>]() // Array of photos with multiple urls for each size
    
    var testArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isPagingEnabled = false
        self.clearsSelectionOnViewWillAppear = false
        
        getDataFromRealm()
    }
    
    func getDataFromRealm() {
        do {
            let realm = try Realm()
            let userPhotos = realm.objects(Photos.self).filter("ownerId == %@", photosForUserID)
            self.allPhotosUrls = Array(userPhotos).map { $0.imageUrl }
            self.allPhotosOfUser = Array(userPhotos)
            collectionView.reloadData()
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_FullScreen_Photo" {
            if let destination = segue.destination as? FullScreenPhotoVC{
                destination.currentIndex = currentImageIndex
                destination.fullAlbum = allPhotosUrls.map { $0[$0.count - 1] }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        allPhotosUrls.count
        allPhotosOfUser.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as? FriendPhotoCollectionViewCell {
            cell.configure(photoUrl: allPhotosUrls[indexPath.item][0])
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        userPhoto = userAlbumOne[indexPath.item]
        currentImageIndex = (indexPath.section + 1) * indexPath.item
        performSegue(withIdentifier: "to_FullScreen_Photo", sender: self)
    }
}

extension FriendPhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = cellInsets.left * (photoPerRow - 1)
        let availableWidth = collectionView.frame.width - spacing
        let photoWidth = availableWidth / photoPerRow
        return CGSize(width: photoWidth, height: photoWidth)
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
