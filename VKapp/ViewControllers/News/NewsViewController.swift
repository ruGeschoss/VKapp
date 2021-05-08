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
  private lazy var refreshControl: UIRefreshControl = { createRefreshControl() }()
  private var news: [NewsPostModel] = []
  private var users: [UserSJ] = []
  private var groups: [Group] = []
  private var cellConfig: [IndexPath: CellConfiguration] = [:]
  private var nextNewsRequestFrom: String = ""
  private var newsAreLoading: Bool = false
  typealias Constant = Constants.News
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    registerReusableViews()
    
    NewsfeedService.getPostNews(startFrom: nil) { (response) in
      DispatchQueue.main.async {
        self.news = response.news
        self.groups = response.groups
        self.users = response.users
        self.nextNewsRequestFrom = response.nextRequest
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
    news[section].text == "" ? 1 : 2
  }
  
  // MARK: - CellForRowAt
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let newsContent = news[indexPath.section]
    if cellConfig[indexPath] == nil {
      cellConfig[indexPath] =
        CellConfiguration(indexPath: indexPath,
                          superviewWidth: newsTableView.bounds.width,
                          height: 0, isExpanded: false)
    }
    
    switch indexPath.row {
    case 0:
      guard newsContent.text != "" else { fallthrough }
      guard let postCell = tableView.dequeueReusableCell(
              withIdentifier: NewsPostTableViewCell.reuseID)
              as? NewsPostTableViewCell else { return UITableViewCell() }
      postCell.cellConfig = cellConfig[indexPath]
      postCell.delegate = self
      postCell.configure(news: newsContent)
      cellConfig[indexPath] = postCell.cellConfig
      return postCell

    default:
      guard
        let imageUrl = newsContent.photoAttachments.first?.imageUrl.last,
        let image = photoService.photo(indexPath: indexPath, url: imageUrl),
        let photoCell = tableView.dequeueReusableCell(
              withIdentifier: NewsPhotoTableViewCell.reuseID)
              as? NewsPhotoTableViewCell else { return UITableViewCell() }
      photoCell.cellConfig = cellConfig[indexPath]
      photoCell.configure(news: newsContent, image: image)
      cellConfig[indexPath] = photoCell.cellConfig
      return photoCell
    }
  }
  
  // MARK: - HeightForRowAt
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    cellConfig[indexPath]?.height ?? newsTableView.bounds.width
  }
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    cellConfig[indexPath]?.height ?? UITableView.automaticDimension
  }
  
     // MARK: - Header
  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsHeaderView.reuseID)
            as? NewsHeaderView else { return UIView() }
    let postOwner = getPostOwner(byId: news[section].sourceId)
    let datePosted = getDatePosted(byIndex: section)
    header.configure(for: postOwner, date: datePosted)
    return header
  }
  
  // MARK: - Header height
  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    Constant.Header.totalHeight
  }
  
  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    Constant.Header.totalHeight
  }
  
  // MARK: - Footer
  func tableView(_ tableView: UITableView,
                 viewForFooterInSection section: Int) -> UIView? {
    guard let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsFooterView.reuseID)
            as? NewsFooterView else { return UIView() }
    footer.configure(post: news[section])
    return footer
  }
  
  // MARK: - Footer height
  func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
    Constant.Footer.totalHeight
  }
  
  func tableView(_ tableView: UITableView,
                 heightForFooterInSection section: Int) -> CGFloat {
    Constant.Footer.totalHeight
  }
}

// MARK: - TableView Delegate
extension NewsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    #if DEBUG
    print("Selected row is \(indexPath.row)")
    print("Selected section is \(indexPath.section)")
    print("CFG is \(String(describing: cellConfig[indexPath]))")
    #endif
  }
}

// MARK: - Cell Expand Delegate
extension NewsViewController: ForcedCellUpdateDelegate {
  func updateCellHeight(newConfig: CellConfiguration) {
    cellConfig[newConfig.indexPath] = newConfig
    newsTableView.reloadRows(at: [newConfig.indexPath], with: .fade)
    newsTableView.scrollToRow(at: newConfig.indexPath,
                              at: .none, animated: true)
  }
}

// MARK: - Setup
extension NewsViewController {
  
  // MARK: Register Views
  private func registerReusableViews() {
    newsTableView.register(
      NewsHeaderView.self,
      forHeaderFooterViewReuseIdentifier: NewsHeaderView.reuseID)
    
    newsTableView.register(
      NewsFooterView.self,
      forHeaderFooterViewReuseIdentifier: NewsFooterView.reuseID)
    
    newsTableView.register(
      NewsPostTableViewCell.self,
      forCellReuseIdentifier: NewsPostTableViewCell.reuseID)
    
    newsTableView.register(
      NewsPhotoTableViewCell.self,
      forCellReuseIdentifier: NewsPhotoTableViewCell.reuseID)
  }
  
  // MARK: Setup TableView
  private func setupTableView() {
    newsTableView.dataSource = self
    newsTableView.delegate = self
    newsTableView.separatorStyle = .none
    newsTableView.refreshControl = refreshControl
    newsTableView.prefetchDataSource = self
    
    newsTableView.backgroundColor = Constant.backgroundColor
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
    NewsfeedService.getPostNews(startFrom: nil) { (response) in
      DispatchQueue.main.async {
        self.news = response.news
        self.groups = response.groups
        self.users = response.users
        self.nextNewsRequestFrom = response.nextRequest
        self.cellConfig.removeAll()
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
    if maxSection > news.count - 5,
       !newsAreLoading {
      newsAreLoading = true
      
      NewsfeedService
        .getPostNews(startFrom: nextNewsRequestFrom) { [weak self] (response) in
          guard let self = self else { return }
          let indexSet = IndexSet(
            integersIn: self.news.count ..< self.news.count + response.news.count)
          self.news.append(contentsOf: response.news)
          self.users.append(contentsOf: response.users)
          self.groups.append(contentsOf: response.groups)
          self.nextNewsRequestFrom = response.nextRequest
          self.newsTableView.insertSections(indexSet, with: .none)
          self.newsAreLoading = false
      }
    }
  }
}

// MARK: - Helpers
extension NewsViewController {
  
  // MARK: Find post owner
  private func getPostOwner(byId ownerId: Int) -> NewsOwner {
    ownerId > 0 ?
      users.filter({ $0.userId == String(ownerId) }).first! :
      groups.filter({ $0.groupId == String(ownerId * ownerId.signum()) }).first!
  }
  
  // MARK: Get date posted
  private func getDatePosted(byIndex index: Int) -> String {
    if news[index].stringDate != nil {
      return news[index].stringDate!
    } else {
      let stringDate = news[index].date.convertToDate()
      news[index].stringDate = stringDate
      return stringDate
    }
  }
}
