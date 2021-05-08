//
//  NewsViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.03.2021.
//

import UIKit

final class NewsViewController: UIViewController {
  @IBOutlet private weak var backgroundView: GradientView!
  @IBOutlet private weak var newsTableView: UITableView!
  
  private var news: [NewsPostModel] = []
  private var users: [UserSJ] = []
  private var groups: [Group] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    registerReusableViews()
    
    NewsfeedService.getPostNews { (news, users, groups, nextFrom) in
      print("Got post news: \(news.count), from: \(users.count) users and \(groups.count) groups")
      print("Next request from: \(nextFrom)")
      DispatchQueue.main.async {
        self.news = news
        self.groups = groups
        self.users = users
        self.newsTableView.reloadData()
      }
    }
    NewsfeedService.getPhotoNews { (news, users, groups, nextFrom) in
      print("Got photo news: \(news.count), from: \(users.count) users and \(groups.count) groups")
      print("Next request from: \(nextFrom)")
      print(news.first?.photos.count)
    }
  }
}

// MARK: - TableView DataSource
extension NewsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    news.count
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch news[section].text != "" {
    case true:
      return 2
    default:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let postCell = tableView.dequeueReusableCell(
            withIdentifier: Constants.newsPostCellId)
            as? NewsPostTableViewCell,
          let photoCell = tableView.dequeueReusableCell(
            withIdentifier: Constants.newsPhotoCellId)
            as? NewsPhotoTableViewCell else { return UITableViewCell() }
    
    guard let attachment = news[indexPath.section].photoAttachments.first,
          let photo = attachment.imageUrl.last else { return UITableViewCell() }
    
    switch indexPath.row {
    case 0:
      if news[indexPath.section].text == "" {
        photoCell.configure(url: photo)
        return photoCell
      }
      postCell.configure(text: news[indexPath.section].text)
      return postCell
    default:
      
      photoCell.configure(url: photo)
      return photoCell
    }
  }
  
  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsHeaderViewId)
            as? NewsHeaderView else { return UIView() }
    
    guard users.first != nil,
          groups.first != nil else { return UIView() }
    
    switch news[section].sourceId > 0 {
    case true:
      let sourceId = news[section].sourceId
      let owner = users.filter { (postOwner) -> Bool in
        return postOwner.userId == String(sourceId)
      }
      header.configureForUser(date: news[section].date, user: owner.first!)
      return header
    case false:
      let sourceId = news[section].sourceId * news[section].sourceId.signum()
      let owner = groups.filter { (postOwner) -> Bool in
        return postOwner.groupId == String(sourceId)
      }
      header.configureForGroup(date: news[section].date, group: owner.first!)
      return header
    }
  }
  
  func tableView(_ tableView: UITableView,
                 viewForFooterInSection section: Int) -> UIView? {
    guard let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsFooterViewId)
            as? NewsFooterView else { return UIView() }
    let post = news[section]
    footer.configure(likes: post.likes, comments: post.comments,
                     reposts: post.reposts, views: post.views)
    return footer
  }
  
  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsHeaderViewId)
            as? NewsHeaderView else { return 0 }
    return header.frame.height
  }
  
  func tableView(_ tableView: UITableView,
                 heightForFooterInSection section: Int) -> CGFloat {
    guard let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsFooterViewId)
            as? NewsFooterView else { return 0 }
    return footer.frame.height
  }
}

// MARK: - TableView Delegate
extension NewsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    #if DEBUG
    print("Selected row is \(indexPath.row)")
    print("Selected section is \(indexPath.section)")
    #endif
  }
}

// MARK: - Functions
extension NewsViewController {
  
  private func registerReusableViews() {
    newsTableView.register(
      Constants.newsHeaderViewNib,
      forHeaderFooterViewReuseIdentifier: Constants.newsHeaderViewId)
    
    newsTableView.register(
      Constants.newsFooterViewNib,
      forHeaderFooterViewReuseIdentifier: Constants.newsFooterViewId)
    
    newsTableView.register(
      Constants.newsPostCellNib,
      forCellReuseIdentifier: Constants.newsPostCellId)
    
    newsTableView.register(
      Constants.newsPhotoCellNib,
      forCellReuseIdentifier: Constants.newsPhotoCellId)
  }
  
  private func setupTableView() {
    newsTableView.dataSource = self
    newsTableView.delegate = self
    newsTableView.separatorStyle = .none
    newsTableView.backgroundColor =
      Constants.newsTableViewBackgroundColor
  }
}
