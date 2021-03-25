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
    setupTableView()
    registerReusableViews()
  }
}

// MARK: - TableView DataSource
extension NewsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    20
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch (section + 1) % 2 {
    case 0:
      return 1
    default:
      return 2
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
    
    switch indexPath.row {
    case 0:
      postCell.configure(text: """
                               Some text to test multilane
                               textfield for news cell and etc
                               """)
      return postCell
    default:
      if (indexPath.section + 1) % 3 == 0 {
        photoCell.configure(image: UIImage(named: "Batz_Maru")!)
      } else {
        photoCell.configure(image: UIImage(named: "photo1")!)
      }
      return photoCell
    }
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
