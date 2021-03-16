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
    
    var photosForUserID = String()           // id of user
    var allPhotosOfUser: Results<Photos>? {  // detailed photo info (if needed more info)
        let realm = try? Realm()
        let photos = realm?.objects(Photos.self).filter("ownerId == %@", photosForUserID)
        return photos?.sorted(byKeyPath: "datePosted", ascending: false)
    }
    var allPhotosUrls: [List<String>]? {     // Array of photos with multiple urls for each size
        let urls = Array(allPhotosOfUser!).map { $0.imageUrl }
        return urls
    }
    private var allPhotosOfUserNotificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        collectionView.isPagingEnabled = false
        self.clearsSelectionOnViewWillAppear = false
        
        createallPhotosNotificationToken()
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGray
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление...", attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_FullScreen_Photo" {
            if let destination = segue.destination as? FullScreenPhotoVC{
                destination.currentIndex = currentImageIndex
                destination.fullAlbum = allPhotosUrls!.map { $0[$0.count - 1] }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allPhotosOfUser!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as? FriendPhotoCollectionViewCell {
            cell.configure(photoUrl: allPhotosUrls![indexPath.item][0])
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentImageIndex = (indexPath.section + 1) * indexPath.item
        performSegue(withIdentifier: "to_FullScreen_Photo", sender: self)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        NetworkManager.loadPhotosSJ(ownerId: photosForUserID) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    private func createallPhotosNotificationToken() {
        allPhotosOfUserNotificationToken = allPhotosOfUser?.observe { [weak self] result in
            switch result {
            case .initial(let allPhotos):
                print("Initiated with \(allPhotos.count) photos")
                self?.collectionView.reloadData()
                break
            case .update(let photos, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print("""
                    New count \(photos.count)
                    Deletions \(deletions)
                    Insertions \(insertions)
                    Modifications \(modifications)
                    """)
                if !deletions.isEmpty || !insertions.isEmpty {
                    self?.collectionView.reloadData()
                }
                
                if !modifications.isEmpty {
                    let modificationsIndexPaths = modifications.map { IndexPath(item: $0, section: 0) }
                    self?.collectionView.reloadItems(at: modificationsIndexPaths)
                }
                
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    deinit {
        allPhotosOfUserNotificationToken?.invalidate()
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