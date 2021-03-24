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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    newsTableView.dataSource = self
    newsTableView.delegate = self
    
    newsTableView.backgroundColor =
      Constants.newsTableViewBackgroundColor
    
    newsTableView.register(
      Constants.newsHeaderViewNib,
      forHeaderFooterViewReuseIdentifier: Constants.newsHeaderViewId)
    
    newsTableView.register(
      Constants.newsFooterViewNib,
      forHeaderFooterViewReuseIdentifier: Constants.newsFooterViewId)
    
    #if DEBUG
    newsTableView.register(MyFriendsTableViewCell.self,
                           forCellReuseIdentifier: "MyFriendCell")
    #endif
  }
}

// MARK: - TableView DataSource
extension NewsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    5
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(
        withIdentifier: "MyFriendCell",
        for: indexPath) as? MyFriendsTableViewCell {
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsHeaderViewId)
            as? NewsHeaderView else { return UIView() }
    header.configure()
    return header
  }
  
  func tableView(_ tableView: UITableView,
                 viewForFooterInSection section: Int) -> UIView? {
    guard let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsFooterViewId)
            as? NewsFooterView else { return UIView() }
    footer.configure()
    return footer
  }
  
  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsHeaderViewId)
            as? NewsHeaderView else { return 0 }
    return header.contentView.frame.height
  }
  
  func tableView(_ tableView: UITableView,
                 heightForFooterInSection section: Int) -> CGFloat {
    guard let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.newsFooterViewId)
            as? NewsFooterView else { return 0 }
    return footer.contentView.frame.height
  }
}

// MARK: - TableView Delegate
extension NewsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    #if DEBUG
    print("Selected row is \(indexPath.row)")
    #endif
  }
}
