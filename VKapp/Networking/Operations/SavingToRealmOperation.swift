//
//  SavingToRealmOperation.swift
//  VKapp
//
//  Created by Alexander Andrianov on 06.04.2021.
//

import Foundation

final class SavingToRealmOperation: Operation {
  private lazy var realm = RealmManager.shared
  
  override func main() {
    guard let parseDataOperation = dependencies.first as? ParseDataOperation,
          !parseDataOperation.outputData.isEmpty else { return }
    let parsedArray = parseDataOperation.outputData
    DispatchQueue.main.async {
      try? self.realm?.add(objects: parsedArray)
    }
  }
}
