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
  
  private lazy var photoService = PhotoService(container: newsTableView)
  private lazy var refreshControl: UIRefreshControl = {
    createRefreshControl()
  }()
  private var news: [NewsPostModel] = []
  private var users: [UserSJ] = []
  private var groups: [Group] = []
  private var aspects: [IndexPath: CGFloat] = [:]
  private var cellHeight: [IndexPath: CGFloat] = [:]
  private var nextNewsRequestFrom: String = ""
  private var newsAreLoading: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    registerReusableViews()
    
    NewsfeedService.getPostNews(startFrom: nil) { (news, users, groups, nextFrom) in
      DispatchQueue.main.async {
        self.news = news
        self.groups = groups
        self.users = users
        self.nextNewsRequestFrom = nextFrom
        self.newsTableView.reloadData()
      }
    }
    
    NewsfeedService.getPhotoNews { (news, users, groups, nextFrom) in
      print("Got photo news: \(news.count), from: \(users.count) users and \(groups.count) groups")
      print("Next photoNews request from: \(nextFrom)")
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
  
  // MARK: - CellForRowAt
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      guard news[indexPath.section].text != "" else { fallthrough }
      guard let postCell = tableView.dequeueReusableCell(
              withIdentifier: NewsPostTableViewCell.reuseID)
              as? NewsPostTableViewCell else { return UITableViewCell() }
      postCell.configure(text: news[indexPath.section].text)
      cellHeight[indexPath] = postCell.cellHeight
      return postCell
      
    default:
//      guard let attachment = news[indexPath.section].photoAttachments.first,
//            let photo = attachment.imageUrl.last,
//            let image = photoService
//              .photo(indexPath: indexPath, url: photo),
//            let photoCell = tableView.dequeueReusableCell(
//                    withIdentifier: Constants.newsPhotoCellId)
//                    as? NewsPhotoTableViewCell
//      else { return UITableViewCell() }
//
//      if aspects[indexPath] == nil {
//        let size = image.size
//        let aspect = size.width / size.height
//        aspects[indexPath] = aspect
//      }
//
//      photoCell.configure(image: image, aspectRatio: aspects[indexPath])
//      return photoCell
      return UITableViewCell()
    }
  }
  
  // MARK: - HeightForRowAt
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard
      let aspect = aspects[indexPath]
    else {
      if cellHeight[indexPath] != nil {
        return cellHeight[indexPath]!
      }
      return UITableView.automaticDimension }
    
    let cellInsets = Constants.newsPhotoCellInsets
    let maxWidth = tableView.bounds.width - cellInsets.left - cellInsets.right
    let height = aspect < 1 ? maxWidth : maxWidth / aspect
    return ceil(height)
  }
     // MARK: - Header
  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
//    guard let header = tableView.dequeueReusableHeaderFooterView(
//            withIdentifier: Constants.newsHeaderViewId)
//            as? NewsHeaderView else { return UIView() }
//
//    guard users.first != nil,
//          groups.first != nil else { return UIView() }
//
//    switch news[section].sourceId > 0 {
//    case true:
//      let sourceId = news[section].sourceId
//      let owner = users.filter { (postOwner) -> Bool in
//        return postOwner.userId == String(sourceId)
//      }
//      header.configureForUser(date: news[section].date, user: owner.first!)
//      return header
//    case false:
//      let sourceId = news[section].sourceId * news[section].sourceId.signum()
//      let owner = groups.filter { (postOwner) -> Bool in
//        return postOwner.groupId == String(sourceId)
//      }
//      header.configureForGroup(date: news[section].date, group: owner.first!)
//      return header
//    }
    return UIView()
  }
  
  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsHeaderViewId)
            as? NewsHeaderView else { return 0 }
    return header.frame.height
  }
  
  // MARK: - Footer
  func tableView(_ tableView: UITableView,
                 viewForFooterInSection section: Int) -> UIView? {
//    guard let footer = tableView.dequeueReusableHeaderFooterView(
//            withIdentifier: Constants.newsFooterViewId)
//            as? NewsFooterView else { return UIView() }
//    let post = news[section]
//    footer.configure(likes: post.likes, comments: post.comments,
//                     reposts: post.reposts, views: post.views)
//    return footer
    return UIView()
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
    
    newsTableView.register(NewsPostTableViewCell.self, forCellReuseIdentifier: NewsPostTableViewCell.reuseID)
    
    newsTableView.register(
      Constants.newsPhotoCellNib,
      forCellReuseIdentifier: Constants.newsPhotoCellId)
  }
  
  private func setupTableView() {
    newsTableView.dataSource = self
    newsTableView.delegate = self
    newsTableView.separatorStyle = .none
    newsTableView.refreshControl = refreshControl
    newsTableView.prefetchDataSource = self
    
    newsTableView.backgroundColor =
      Constants.newsTableViewBackgroundColor
  }
  
  // MARK: - Refresh Control
  private func createRefreshControl() -> UIRefreshControl {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .systemGray
    refreshControl.attributedTitle =
      NSAttributedString(
        string: "Обновление...",
        attributes: [.font: UIFont.systemFont(ofSize: 10)])
    refreshControl.addTarget(
      self, action: #selector(refresh(_:)),
      for: .valueChanged)
    return refreshControl
  }
  
  @objc private func refresh(_ sender: UIRefreshControl) {
    NewsfeedService.getPostNews(startFrom: nil) { (news, users, groups, nextFrom) in
      DispatchQueue.main.async {
        self.news = news
        self.groups = groups
        self.users = users
        self.nextNewsRequestFrom = nextFrom
        self.refreshControl.endRefreshing()
        self.newsTableView.reloadData()
      }
    }
  }
}

// MARK: - DataSource Prefetching
extension NewsViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView,
                 prefetchRowsAt indexPaths: [IndexPath]) {
    guard
      let maxSection = indexPaths.map({ $0.section }).max()
    else { return }
    
    if maxSection > news.count - 3,
       !newsAreLoading {
      newsAreLoading = true
      
      NewsfeedService
        .getPostNews(startFrom: nextNewsRequestFrom) { [weak self] (news, users, groups, nextFrom) in
          guard let self = self else { return }
          let indexSet = IndexSet(
            integersIn: self.news.count ..< self.news.count + news.count)
          self.news.append(contentsOf: news)
          self.users.append(contentsOf: users)
          self.groups.append(contentsOf: groups)
          self.nextNewsRequestFrom = nextFrom
          self.newsTableView.insertSections(indexSet, with: .none)
          self.newsAreLoading = false
      }
    }
  }
}
