//
//  Structs.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.04.2021.
//

import UIKit

// MARK: Cell configuration
struct CellConfiguration {
  let indexPath: IndexPath
  var height: CGFloat
  var superviewWidth: CGFloat
  var isExpanded: Bool?
  
  init(indexPath: IndexPath, superviewWidth: CGFloat, height: CGFloat, isExpanded: Bool?) {
    self.indexPath = indexPath
    self.superviewWidth = superviewWidth
    self.height = height
    self.isExpanded = isExpanded
  }
}

// MARK: NewsFeed Response
struct NewsFeedResponse {
  let news: [NewsPostModel]
  let users: [UserSJ]
  let groups: [Group]
  let nextRequest: String
  
  init(news: [NewsPostModel], users: [UserSJ],
       groups: [Group], nextRequest: String) {
    self.news = news
    self.users = users
    self.groups = groups
    self.nextRequest = nextRequest
  }
}
