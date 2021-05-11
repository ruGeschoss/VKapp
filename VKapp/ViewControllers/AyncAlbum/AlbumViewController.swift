//
//  AlbumViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 10.05.2021.
//

import UIKit

class AlbumViewController: UIViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    let asyncVC = AsyncAlbumTable()
    navigationController?.pushViewController(asyncVC, animated: true)
  }
}
