//
//  ParseDataOperation.swift
//  VKapp
//
//  Created by Alexander Andrianov on 06.04.2021.
//

import Foundation
import SwiftyJSON

final class ParseDataOperation: Operation {
  
  var outputData: [UserSJ] = []
  
  override func main() {
    guard let requestDataOperation = dependencies.first as? RequestDataOperation,
          let data = requestDataOperation.data else { return }
    let target = requestDataOperation.target
    let json = JSON(data)
    let items = json["response"]["items"].arrayValue
    let friends = items
      .map { UserSJ(from: $0) }
      .filter { $0.lastName != "" }
    friends.forEach { $0.forUser = target }
    outputData = friends
  }
}
