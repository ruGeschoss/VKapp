//
//  PhotoService.swift
//  VKapp
//
//  Created by Alexander Andrianov on 09.04.2021.
//

import Foundation
import Alamofire

private protocol DataReloadable {
  func reloadRow(indexPath: IndexPath)
}

final class PhotoService {
  
  private let cacheLifetime: TimeInterval = 7 * 24 * 60 * 60
  private var images = [String: UIImage]()
  private let container: DataReloadable
  private static let pathName: String = {
    let pathName = "images"
    
    guard
      let cachesDirectory = FileManager.default
        .urls(for: .cachesDirectory, in: .userDomainMask)
        .first
    else { return pathName }
    
    let url = cachesDirectory
      .appendingPathComponent(pathName, isDirectory: true)
    
    if !FileManager.default.fileExists(atPath: url.path) {
      try? FileManager.default.createDirectory(
        at: url, withIntermediateDirectories: true,
        attributes: nil)
    }
    return pathName
  }()
  
  init(container: UITableView) {
    self.container = Table(table: container)
  }
  
  init(container: UICollectionView) {
    self.container = Collection(collection: container)
  }
  
  // MARK: - Get file path
  private func getFilePath(url: String) -> String? {
    guard
      let cachesDirectory = FileManager.default
        .urls(for: .cachesDirectory, in: .userDomainMask)
        .first
    else { return nil }
    
    let hashName = url.split(separator: "/").last ?? "default"
    
    return cachesDirectory
      .appendingPathComponent(Self.pathName + "/" + hashName)
      .path
  }
  
  // MARK: - Save image to cache
  private func saveImageToCache(url: String, image: UIImage) {
    guard
      let fileName = getFilePath(url: url),
      let data = image.pngData()
    else { return }
    
    FileManager.default
      .createFile(atPath: fileName, contents: data, attributes: nil)
  }
  
  // MARK: - Get image from cache
  private func getImageFromCache(url: String) -> UIImage? {
    guard
      let fileName = getFilePath(url: url),
      let info = try? FileManager.default.attributesOfItem(atPath: fileName),
      let modificationDate = info[FileAttributeKey.modificationDate] as? Date
    else { return nil }
    
    let lifeTime = Date().timeIntervalSince(modificationDate)
    
    guard
      lifeTime <= cacheLifetime,
      let image = UIImage(contentsOfFile: fileName)
    else { return nil }
    
    DispatchQueue.main.async {
      self.images[url] = image
    }
    return image
  }
  
  // MARK: - Load image from web
  private func loadImage(indexPath: IndexPath, url: String) {
    AF.request(url).responseData(queue: .global()) { [weak self] response in
      guard
        let data = response.data,
        let image = UIImage(data: data)
      else { return }
      DispatchQueue.main.async {
        self?.images[url] = image
      }
      self?.saveImageToCache(url: url, image: image)
      DispatchQueue.main.async {
        self?.container.reloadRow(indexPath: indexPath)
      }
    }
  }
  
  // MARK: - Set photo from cache or web
  func photo(indexPath: IndexPath, url: String) -> UIImage? {
    var image: UIImage?
    
    if let photo = images[url] {
      image = photo
    } else if let photo = getImageFromCache(url: url) {
      image = photo
    } else {
      loadImage(indexPath: indexPath, url: url)
    }
    
    return image
  }
}

// MARK: - Table + Collection
extension PhotoService {
  private class Table: DataReloadable {
    let table: UITableView
    
    init(table: UITableView) {
      self.table = table
    }
    
    func reloadRow(indexPath: IndexPath) {
      table.reloadRows(at: [indexPath], with: .automatic)
    }
  }
  
  private class Collection: DataReloadable {
    let collection: UICollectionView
    
    init(collection: UICollectionView) {
      self.collection = collection
    }
    
    func reloadRow(indexPath: IndexPath) {
      collection.reloadItems(at: [indexPath])
    }
  }
}
