//
//  FriendPhotoCollectionViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import RealmSwift

final class FriendPhotoCollectionViewController: UICollectionViewController {
  private var allPhotosOfUserNotificationToken: NotificationToken?
  private var testToken: NotificationToken?
  private lazy var realm = RealmManager.shared
  private lazy var photoService = PhotoService(container: self.collectionView)
  var currentImageIndex = 0
  var photosForUserID = String()
  
  var allPhotosOfUser: Results<Photos>? {
    getSortedPhotos()
  }
  
  private var allPhotosUrls: [List<String>]? {
    Array(allPhotosOfUser!).map { $0.imageUrl }
  }
  
  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .systemGray
    refreshControl.attributedTitle =
      NSAttributedString(
        string: "Обновление...",
        attributes: [.font: UIFont.systemFont(ofSize: 10)])
    refreshControl.addTarget(self, action: #selector(refresh(_:)),
                             for: .valueChanged)
    return refreshControl
  }()
  
  deinit {
    allPhotosOfUserNotificationToken?.invalidate()
  }
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.refreshControl = refreshControl
    collectionView.isPagingEnabled = false
    self.clearsSelectionOnViewWillAppear = true
    
    createSingleTargetToken()
    createallPhotosNotificationToken()
  }
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if segue.identifier == "to_FullScreen_Photo" {
      if let destination = segue.destination as? FullScreenPhotoVC {
        destination
          .currentIndex = currentImageIndex
        destination
          .fullAlbum = allPhotosUrls!.map { ($0[$0.count - 1]) }
      }
    }
  }
}

// MARK: - Datasource
extension FriendPhotoCollectionViewController {
  
  override func numberOfSections(
    in collectionView: UICollectionView) -> Int {
    1
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    guard let allPhotosCount = allPhotosOfUser?.count else { return 0 }
    return allPhotosCount
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView
        .dequeueReusableCell(
          withReuseIdentifier: "FriendPhotoCell",
          for: indexPath) as? FriendPhotoCollectionViewCell {
      let maxQualityPhoto = allPhotosUrls![indexPath.item].last!
      let photo = photoService
        .photo(indexPath: indexPath, url: maxQualityPhoto)
      cell.friendAlbumPhoto.image = photo
      return cell
    }
    return UICollectionViewCell()
  }
}

// MARK: - Delegate
extension FriendPhotoCollectionViewController {
  
  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
    currentImageIndex = (indexPath.section + 1) * indexPath.item
    performSegue(withIdentifier: "to_FullScreen_Photo", sender: self)
  }
  
  @objc private func refresh(_ sender: UIRefreshControl) {
    NetworkManager
      .loadPhotosSJ(ownerId: photosForUserID) { [weak self] in
        self?.refreshControl.endRefreshing()
    }
  }
}

// MARK: - Functions
extension FriendPhotoCollectionViewController {
  
  // Single target observer
  private func createSingleTargetToken() {
    guard let allPhotosOfUser = allPhotosOfUser,
          allPhotosOfUser.count != 0 else { return }
    testToken = allPhotosOfUser.last?.observe { change in
      switch change {
      case .change(let object, let properties):
        let changes = properties.reduce("") { (res, new) in
          """
          \(res)\n\(new.name):
          \t\(new.oldValue ?? "nil")
          -> \(new.newValue ?? "nil")
          """
        }
        let photos = object as? Photos
        #if DEBUG
        print("""
              Changed properties for photoID:
              \(photos?.photoId ?? "")\n\(changes)
              """)
        #endif
      case .deleted:
        print("obj deleted")
      case .error(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  // Collection observer
  private func createallPhotosNotificationToken() {
    allPhotosOfUserNotificationToken = allPhotosOfUser?
      .observe { [weak self] result in
      switch result {
      case .initial(let allPhotos):
        print("Initiated with \(allPhotos.count) photos")
        self?.collectionView.reloadData()
      case .update(let photos,
                   deletions: let deletions,
                   insertions: let insertions,
                   modifications: let modifications):
        print("""
              New count \(photos.count)
              Deletions \(deletions)
              Insertions \(insertions)
              Modifications \(modifications)
              """)
        let modificationsIndexPaths = modifications
          .map { IndexPath(item: $0, section: 0) }
        let insertionsIndexPaths = insertions
          .map { IndexPath(item: $0, section: 0) }
        let deletionsIndexPaths = deletions
          .map { IndexPath(item: $0, section: 0) }
        
        DispatchQueue.main.async {
          self?.collectionView.performBatchUpdates {
              self?.collectionView.insertItems(at: insertionsIndexPaths)
              self?.collectionView.deleteItems(at: deletionsIndexPaths)
              self?.collectionView.reloadItems(at: modificationsIndexPaths)
          }
        }
      case .error(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  // Preparing array for usage
  private func getSortedPhotos() -> Results<Photos>? {
    let photos = realm?
      .getObjects(type: Photos.self)
      .filter("ownerId == %@", photosForUserID)
      .sorted(byKeyPath: "datePosted", ascending: false)
    return photos
  }
}
